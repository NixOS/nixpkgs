{ stdenv, lib, fetchFromGitHub, cmake, libusb1, pkg-config, freeglut, libGLU, libGL, libXi, libXmu
, GLUT, Cocoa
 }:

stdenv.mkDerivation rec {
  pname = "freenect";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "OpenKinect";
    repo = "libfreenect";
    rev = "v${version}";
    sha256 = "sha256-/CR+r9/zMj+8gxhHeRGPCDhALeF5bLsea38KQ1lF6wo=";
  };

  buildInputs = [ libusb1 freeglut libGLU libGL libXi libXmu ]
    ++ lib.optionals stdenv.isDarwin [ GLUT Cocoa ];

  nativeBuildInputs = [ cmake pkg-config ];

  meta = {
    description = "Drivers and libraries for the Xbox Kinect device on Windows, Linux, and macOS";
    homepage = "http://openkinect.org";
    license = with lib.licenses; [ gpl2 asl20 ];
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = with lib.platforms; linux ++ darwin ;
  };
}
