{ stdenv
, fetchurl
, pkgconfig
, guile
, libGL
, libGLU
, freeglut
}:

let
  name = "guile-opengl-${version}";
  version = "0.1.0";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/guile-opengl/${name}.tar.gz";
    sha256 = "13qfx4xh8baryxqrv986l848ygd0piqwm6s2s90pxk9c0m9vklim";
  };

  patchPhase = ''
    substituteInPlace glx/runtime.scm \
      --replace '(dynamic-link "libGL")' '(dynamic-link "${libGL}/lib/libGL.so")'
    substituteInPlace glu/runtime.scm \
      --replace '(dynamic-link "libGLU")' '(dynamic-link "${libGLU}/lib/libGLU.so")'
    substituteInPlace glut/runtime.scm \
      --replace '(dynamic-link "libglut")' '(dynamic-link "${freeglut}/lib/libglut.so")'
  '';

  nativeBuildInputs = [ pkgconfig guile ];

  meta = with stdenv.lib; {
    description = "Guile bindings for the OpenGL graphics API";
    homepage = "https://www.gnu.org/software/guile-opengl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
