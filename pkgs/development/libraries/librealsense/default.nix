{ stdenv, fetchFromGitHub, cmake, libusb1, ninja, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "librealsense";
  version = "2.32.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l45hrb3lgjh1kdi4khqhljndc434zf9llzbii6dcv911gxkipjr";
  };

  buildInputs = [
    libusb1
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=false" ];

  meta = with stdenv.lib; {
    description = "A cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
