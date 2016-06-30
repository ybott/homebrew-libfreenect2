class Libfreenect2 < Formula
  desc "Drivers/Example for Kinect V2"
  homepage "https://github.com/OpenKinect/libfreenect2"
  url "https://github.com/OpenKinect/libfreenect2/archive/v0.2.0.tar.gz"
  sha256 "344019f4360d3858f4c5843e215b0b9d0c0d396a2ebe5cb1953c262df4d9ff54"

  depends_on "libusb"
  depends_on "nasm" => :optional
  depends_on "jpeg-turbo" => :optional
  depends_on "homebrew/science/opencv" => :optional
  depends_on "homebrew/versions/glfw3" => :optional
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/'test_null.cpp').write <<-EOS.undent
      #include <iostream>
      #include <signal.h>
      #include "libfreenect2/libfreenect2.hpp"
      int main() {
        libfreenect2::Freenect2 freenect2;
        freenect2.enumerateDevices();
        return 0;
      }
    EOS
    system ENV.cc, "test_null.cpp", "-L lib/libfreenect2.dylib", "-o", "test_null"
    system "./test_null"
  end
end

__END__
diff --git a/cmake_modules/FindLibUSB.cmake b/cmake_modules/FindLibUSB.cmake
index 366ff51..068fe4a 100644
--- a/cmake_modules/FindLibUSB.cmake
+++ b/cmake_modules/FindLibUSB.cmake
@@ -9,7 +9,6 @@
 
 IF(PKG_CONFIG_FOUND)
   IF(DEPENDS_DIR) #Otherwise use System pkg-config path
-    SET(ENV{PKG_CONFIG_PATH} "${DEPENDS_DIR}/libusb/lib/pkgconfig")
   ENDIF()
   SET(MODULE "libusb-1.0")
   IF(CMAKE_SYSTEM_NAME MATCHES "Linux")
