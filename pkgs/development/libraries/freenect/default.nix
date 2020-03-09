{ stdenv, lib, fetchFromGitHub, cmake, libusb, pkgconfig, freeglut, libGLU, libGL, libXi, libXmu
, GLUT, Cocoa
 }:

stdenv.mkDerivation rec {
  pname = "freenect";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "OpenKinect";
    repo = "libfreenect";
    rev = "v${version}";
    sha256 = "1963xndbiwgj01q17zv6xbqlsbhfd236dkbdwkbjw4b0gr8kqzq9";
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
