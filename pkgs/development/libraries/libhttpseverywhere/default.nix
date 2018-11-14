{ stdenv, fetchurl, pkgconfig, meson, ninja, makeFontsConf
, gnome3, glib, json-glib, libarchive, libsoup, gobjectIntrospection }:

let
  pname = "libhttpseverywhere";
  version = "0.8.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1jmn6i4vsm89q1axlq4ajqkzqmlmjaml9xhw3h9jnal46db6y00w";
  };

  nativeBuildInputs = [ gnome3.vala gobjectIntrospection meson ninja pkgconfig ];
  buildInputs = [ glib gnome3.libgee json-glib libsoup libarchive ];

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
