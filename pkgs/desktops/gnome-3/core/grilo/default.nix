{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, vala, glib, liboauth, gtk3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, libxml2, gnome3, gobject-introspection, libsoup, totem-pl-parser }:

let
  pname = "grilo";
  version = "0.3.7"; # if you change minor, also change ./setup-hook.sh
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "man" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1dz965l743r4bhj78wij9k1mb6635gnkb1lnk9j7gw9dd5qsyfza";
  };

  patches = [
    # Fix meson build: https://gitlab.gnome.org/GNOME/grilo/merge_requests/34
    (fetchurl {
      url = "https://gitlab.gnome.org/GNOME/grilo/commit/166612aeff09e5fc2fec1f62185c84cbdcf8f889.diff";
      sha256 = "07zamy927iaa7knrwq5yxz7ypl1i02pymkcdrg5l55alhdvb81pw";
    })
  ];

  setupHook = ./setup-hook.sh;

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext gobject-introspection vala
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ glib liboauth gtk3 libxml2 libsoup totem-pl-parser ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Grilo;
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
