{ stdenv, fetchurl, mkPythonDerivation, python, pkgconfig, glib, gobjectIntrospection, pycairo, cairo, which, ncurses}:

mkPythonDerivation rec {
  major = "3.20";
  minor = "0";
  name = "pygobject-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${major}/${name}.tar.xz";
    sha256 = "0ikzh3l7g1gjh8jj8vg6mdvrb25svp63gxcam4m0i404yh0lgari";
  };

  buildInputs = [ pkgconfig glib gobjectIntrospection ]
                 ++ stdenv.lib.optionals stdenv.isDarwin [ which ncurses ];
  propagatedBuildInputs = [ pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
    platforms = stdenv.lib.platforms.unix;
  };
}
