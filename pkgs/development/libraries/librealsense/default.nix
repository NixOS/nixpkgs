{ stdenv, fetchFromGitHub, cmake, libusb, ninja, pkgconfig}:

stdenv.mkDerivation rec {
  name = "librealsense-${version}";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = "librealsense";
    rev = "v${version}";
    sha256 = "1r27pdisg4hl4x23lrmykqfdc5agrc4pi161mhvzd1vjfkjrxbid";
  };

  buildInputs = [
    libusb
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=false" ];

  meta = with stdenv.lib; {
    description = "A cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = https://github.com/IntelRealSense/librealsense;
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn ];
    platforms = platforms.unix;
  };
}
