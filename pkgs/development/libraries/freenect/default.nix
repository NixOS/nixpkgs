{ stdenv, fetchFromGitHub, cmake, libusb, pkgconfig, freeglut, libGLU_combined, libXi, libXmu }:

stdenv.mkDerivation rec {
  name = "freenect-${version}";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "OpenKinect";
    repo = "libfreenect";
    rev = "v${version}";
    sha256 = "0qmbagfkxjgbwd2ajn7i5lkic9gx5y02bsnmqm7cjay99zfw9ifx";
  };

  buildInputs = [ libusb freeglut libGLU_combined libXi libXmu ];
  nativeBuildInputs = [ cmake pkgconfig ];

  meta = {
    description = "Drivers and libraries for the Xbox Kinect device on Windows, Linux, and macOS";
    inherit version;
    homepage = http://openkinect.org;
    license = with stdenv.lib.licenses; [ gpl2 asl20 ];
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = stdenv.lib.platforms.linux;
  };
}
