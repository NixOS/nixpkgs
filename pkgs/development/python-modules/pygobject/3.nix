{ stdenv, fetchurl, buildPythonPackage, pkgconfig, glib, gobject-introspection,
pycairo, cairo, which, ncurses, meson, ninja, isPy3k, gnome3 }:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.30.4";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hscyvr6hh8l90fyz97b9d03506g3r8s5hl1bgk5aadq8jja3h9d";
  };

  outputs = [ "out" "dev" ];

  mesonFlags = [
    "-Dpython=python${if isPy3k then "3" else "2" }"
  ];

  nativeBuildInputs = [ pkgconfig meson ninja gobject-introspection ];
  buildInputs = [ glib gobject-introspection ]
                 ++ stdenv.lib.optionals stdenv.isDarwin [ which ncurses ];
  propagatedBuildInputs = [ pycairo cairo ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "python3.pkgs.${pname}3";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://pygobject.readthedocs.io/;
    description = "Python bindings for Glib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
