{ lib, stdenv, fetchurl, buildPythonPackage, pkg-config, glib, gobject-introspection,
pycairo, cairo, which, ncurses, meson, ninja, isPy3k, gnome3 }:

buildPythonPackage rec {
  pname = "pygobject";
  version = "3.40.0";

  disabled = ! isPy3k;

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0pwhxnk92nvnghxi10wgvqyiq3yf09l2ig6cxpr3pa2skyn1zmk7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config meson ninja gobject-introspection ];
  buildInputs = [ glib gobject-introspection ]
                 ++ lib.optionals stdenv.isDarwin [ which ncurses ];
  propagatedBuildInputs = [ pycairo cairo ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "python3.pkgs.${pname}3";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://pygobject.readthedocs.io/";
    description = "Python bindings for Glib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
