{ stdenv, fetchurl, pkgconfig, vala, glib, libxslt, gtk, wrapGAppsHook
, webkitgtk, json-glib, rest, libsecret, gtk-doc, gobject-introspection
, gettext, icu, glib-networking
, libsoup, docbook_xsl, docbook_xml_dtd_412, gnome3, gcr, kerberos
}:

let
  pname = "gnome-online-accounts";
  version = "3.30.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0havx26cfy0ln17jzmzbrrx35afknv2s9mdy34j0p7wmbqr8m5ky";
  };

  outputs = [ "out" "man" "dev" "devdoc" ];

  configureFlags = [
    "--enable-media-server"
    "--enable-kerberos"
    "--enable-lastfm"
    "--enable-todoist"
    "--enable-gtk-doc"
    "--enable-documentation"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig gobject-introspection vala gettext wrapGAppsHook
    libxslt docbook_xsl docbook_xml_dtd_412 gtk-doc
  ];
  buildInputs = [
    glib gtk webkitgtk json-glib rest libsecret glib-networking icu libsoup
    gcr kerberos
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
