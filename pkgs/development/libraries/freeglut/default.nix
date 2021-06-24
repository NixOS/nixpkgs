{ lib, stdenv, fetchurl, libXi, libXrandr, libXxf86vm, libGL, libGLU, xlibsWrapper, cmake }:

let version = "3.2.1";
in stdenv.mkDerivation {
  pname = "freeglut";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${version}.tar.gz";
    sha256 = "0s6sk49q8ijgbsrrryb7dzqx2fa744jhx1wck5cz5jia2010w06l";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libXi libXrandr libXxf86vm libGL libGLU xlibsWrapper ];

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
    homepage = "http://freeglut.sourceforge.net/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
