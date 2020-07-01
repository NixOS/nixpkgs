{ stdenv, lib, fetchFromGitHub, cmake, libusb1, pkgconfig, freeglut, libGLU, libGL, libXi, libXmu
, GLUT, Cocoa
 }:

stdenv.mkDerivation rec {
  pname = "freenect";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "OpenKinect";
    repo = "libfreenect";
    rev = "v${version}";
    sha256 = "0was1va167rqshmpn382h36yyprpfi9cwillb6ylppmnfdrfrhrr";
  };

  buildInputs = [ libusb1 freeglut libGLU libGL libXi libXmu ]
    ++ lib.optionals stdenv.isDarwin [ GLUT Cocoa ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = {
    description = "Drivers and libraries for the Xbox Kinect device on Windows, Linux, and macOS";
    inherit version;
    homepage = "http://openkinect.org";
    license = with lib.licenses; [ gpl2 asl20 ];
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = with lib.platforms; linux ++ darwin ;
  };
}
