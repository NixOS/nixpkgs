{ stdenv, fetchurl, libXi, libXrandr, libXxf86vm, mesa, xlibsWrapper, cmake }:

let version = "3.0.0";
in stdenv.mkDerivation {
  name = "freeglut-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${version}.tar.gz";
    sha256 = "18knkyczzwbmyg8hr4zh8a1i5ga01np2jzd1rwmsh7mh2n2vwhra";
  };

  buildInputs = [ libXi libXrandr libXxf86vm mesa xlibsWrapper cmake ];

  cmakeFlags = stdenv.lib.optionals stdenv.isDarwin [
                 "-DOPENGL_INCLUDE_DIR=${mesa}/include"
                 "-DOPENGL_gl_LIBRARY:FILEPATH=${mesa}/lib/libGL.dylib"
                 "-DOPENGL_glu_LIBRARY:FILEPATH=${mesa}/lib/libGLU.dylib"
                 "-DFREEGLUT_BUILD_DEMOS:BOOL=OFF"
                 "-DFREEGLUT_BUILD_STATIC:BOOL=OFF"
               ];

  meta = with stdenv.lib; {
    description = "Create and manage windows containing OpenGL contexts";
    longDescription = ''
      FreeGLUT is an open source alternative to the OpenGL Utility Toolkit
      (GLUT) library. GLUT (and hence FreeGLUT) allows the user to create and
      manage windows containing OpenGL contexts on a wide range of platforms
      and also read the mouse, keyboard and joystick functions. FreeGLUT is
      intended to be a full replacement for GLUT, and has only a few
      differences.
    '';
    homepage = http://freeglut.sourceforge.net/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
