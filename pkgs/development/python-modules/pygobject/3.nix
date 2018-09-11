{ stdenv, fetchurl, buildPythonPackage, pkgconfig, glib, gobjectIntrospection,
pycairo, cairo, which, ncurses, meson, ninja, isPy3k, gnome3 }:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.30.1";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1khivip6fnnv3rn0920610zgrf39lf1i5v07w8dbz1b8wdq5ncz1";
  };

  outputs = [ "out" "dev" ];

  mesonFlags = [
    "-Dpython=python${if isPy3k then "3" else "2" }"
  ];

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ glib gobjectIntrospection ]
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
