{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, vala, glib, liboauth, gtk3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43
, libxml2, gnome3, gobject-introspection, libsoup, totem-pl-parser }:

let
  pname = "grilo";
  version = "0.3.13"; # if you change minor, also change ./setup-hook.sh
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "man" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0ywjvh7xw4ql1q4fvl0q5n06n08pga1g1nc9l7c3x5214gr3fj6i";
  };

  setupHook = ./setup-hook.sh;

  mesonFlags = [
    "-Denable-gtk-doc=true"
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext gobject-introspection vala
    gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ glib liboauth gtk3 libxml2 libsoup totem-pl-parser ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Grilo";
    description = "Framework that provides access to various sources of multimedia content, using a pluggable system";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
