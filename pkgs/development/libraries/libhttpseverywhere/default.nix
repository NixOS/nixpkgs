{ stdenv, fetchurl, pkgconfig, meson, ninja, makeFontsConf, vala, fetchpatch
, gnome3, glib, json-glib, libarchive, libsoup, gobject-introspection, valadoc }:

let
  pname = "libhttpseverywhere";
  version = "0.8.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1jmn6i4vsm89q1axlq4ajqkzqmlmjaml9xhw3h9jnal46db6y00w";
  };

  nativeBuildInputs = [ vala gobject-introspection meson ninja pkgconfig ];
  buildInputs = [ glib gnome3.libgee json-glib libsoup libarchive ];

  # Fixes build with vala >=0.42
  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libhttpseverywhere/commit/6da08ef1ade9ea267cecf14dd5cb2c3e6e5e50cb.patch";
      sha256 = "1nwjlh8iqgjayccwdh0fbpq2g1h8bg1k1g9i324f2bhhvyhmpq8f";
    })
  ];

  mesonFlags = [ "-Denable_valadoc=true" ];

  doCheck = true;

  checkPhase = "(cd test && ./httpseverywhere_test)";

  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  outputs = [ "out" "devdoc" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Library to use HTTPSEverywhere in desktop applications";
    homepage = https://gitlab.gnome.org/GNOME/libhttpseverywhere;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sternenseemann ] ++ gnome3.maintainers;
  };
}
