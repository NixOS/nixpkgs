{ stdenv, fetchurl, pkgconfig, guile }:

stdenv.mkDerivation rec {
  name = "guile-opengl-0.1.0";

  meta = with stdenv.lib; {
    description = "Guile binding for the OpenGL graphics API";
    homepage    = "http://gnu.org/s/guile-opengl";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://gnu/guile-opengl/${name}.tar.gz";
    sha256 = "13qfx4xh8baryxqrv986l848ygd0piqwm6s2s90pxk9c0m9vklim";
  };

  nativeBuildInputs = [ pkgconfig guile ];
}
