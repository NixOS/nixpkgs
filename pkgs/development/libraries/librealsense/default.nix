{ stdenv, fetchFromGitHub, cmake, libusb, ninja, pkgconfig}:

stdenv.mkDerivation rec {
  name = "librealsense-${version}";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = "librealsense";
    rev = "v${version}";
    sha256 = "12918gcn0w5h6bqgx6s44w44bs1x2pcndn2833xzya69rddkdv6x";
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
    platforms = ["i686-linux" "x86_64-linux" "x86_64-darwin"];
  };
}
