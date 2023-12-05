{ lib, stdenv, fetchurl, libICE, libXext, libXi, libXrandr, libXxf86vm, libGL, libGLU, cmake
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeglut";
  version = "3.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeglut/freeglut-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-PAvLkV2bGAqX7a69ARt6HeVFg6g4ZE3NQrsOoMbz6uw=";
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

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

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
    pkgConfigModules = [ "glut" ];
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
})
