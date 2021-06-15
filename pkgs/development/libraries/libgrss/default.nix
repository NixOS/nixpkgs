{ lib, stdenv, fetchurl, pkg-config, vala, gobject-introspection, gtk-doc, docbook_xsl, docbook_xml_dtd_412, glib, libxml2, libsoup, gnome }:

let
  version = "0.7.0";
  pname = "libgrss";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nalslgyglvhpva3px06fj6lv5zgfg0qmj0sbxyyl5d963vc02b7";
  };

  nativeBuildInputs = [ pkg-config vala gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_412 ];
  buildInputs = [ glib libxml2 libsoup ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Glib abstaction to handle feeds in RSS, Atom and other formats";
    homepage = "https://wiki.gnome.org/Projects/Libgrss";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
