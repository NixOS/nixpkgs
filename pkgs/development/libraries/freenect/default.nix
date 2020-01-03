{ stdenv, lib, fetchFromGitHub, cmake, libusb, pkgconfig, freeglut, libGLU, libGL, libXi, libXmu
, GLUT, Cocoa
 }:

stdenv.mkDerivation rec {
  pname = "freenect";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "OpenKinect";
    repo = "libfreenect";
    rev = "v${version}";
    sha256 = "0vnc7z2avckh4mccqq6alsd2z7xvsh3kaslc5b0gnfxw0j269gl6";
  };

  buildInputs = [ libusb freeglut libGLU libGL libXi libXmu ]
    ++ lib.optionals stdenv.isDarwin [ GLUT Cocoa ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = {
    description = "Drivers and libraries for the Xbox Kinect device on Windows, Linux, and macOS";
    inherit version;
    homepage = http://openkinect.org;
    license = with lib.licenses; [ gpl2 asl20 ];
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = with lib.platforms; linux ++ darwin ;
  };
}
