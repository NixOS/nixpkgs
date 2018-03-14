{ stdenv, fetchFromGitHub, cmake, libusb, pkgconfig, freeglut, libGLU_combined, libXi, libXmu }:

stdenv.mkDerivation rec {
  name = "freenect-${version}";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "OpenKinect";
    repo = "libfreenect";
    rev = "v${version}";
    sha256 = "0vnc7z2avckh4mccqq6alsd2z7xvsh3kaslc5b0gnfxw0j269gl6";
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
