{ stdenv, fetchurl, buildPythonPackage, python, pkgconfig, glib, gobjectIntrospection, pycairo, cairo, which, ncurses}:

buildPythonPackage rec {
  major = "3.24";
  minor = "1";
  name = "pygobject-${major}.${minor}";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/pygobject/${major}/${name}.tar.xz";
    sha256 = "1zdzznrj2s1gsrv2z4r0n88fzba8zjc1n2r313xi77lhl1daja56";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gobjectIntrospection ]
                 ++ stdenv.lib.optionals stdenv.isDarwin [ which ncurses ];
  propagatedBuildInputs = [ pycairo cairo ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
    platforms = stdenv.lib.platforms.unix;
  };
}
