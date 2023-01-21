{ lib, stdenv, fetchurl, libICE, libXext, libXi, libXrandr, libXxf86vm, libGL, libGLU, cmake }:

stdenv.mkDerivation rec {
  pname = "freeglut";
  version = "3.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${version}.tar.gz";
    sha256 = "sha256-xZRKCC3wu6lrV1bd2x910M1yzie1OVxsHd6Fwv8pelA=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libICE libXext libXi libXrandr libXxf86vm libGL libGLU ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
                 "-DOPENGL_INCLUDE_DIR=${libGL}/include"
                 "-DOPENGL_gl_LIBRARY:FILEPATH=${libGL}/lib/libGL.dylib"
                 "-DOPENGL_glu_LIBRARY:FILEPATH=${libGLU}/lib/libGLU.dylib"
                 "-DFREEGLUT_BUILD_DEMOS:BOOL=OFF"
                 "-DFREEGLUT_BUILD_STATIC:BOOL=OFF"
               ];

  meta = with lib; {
    description = "Create and manage windows containing OpenGL contexts";
    longDescription = ''
      FreeGLUT is an open source alternative to the OpenGL Utility Toolkit
      (GLUT) library. GLUT (and hence FreeGLUT) allows the user to create and
      manage windows containing OpenGL contexts on a wide range of platforms
      and also read the mouse, keyboard and joystick functions. FreeGLUT is
      intended to be a full replacement for GLUT, and has only a few
      differences.
    '';
    homepage = "https://freeglut.sourceforge.net/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
