{ stdenv
, fetchurl
, pkgconfig
, vala
, glib
, libxslt
, gtk3
, wrapGAppsHook
, webkitgtk
, json-glib
, librest
, libsecret
, gtk-doc
, gobject-introspection
, gettext
, icu
, glib-networking
, libsoup
, docbook_xsl
, docbook_xml_dtd_412
, gnome3
, gcr
, kerberos
}:

stdenv.mkDerivation rec {
  pname = "gnome-online-accounts";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0fkqckqkkah5k1xrfqjkk4345aq9c0a6yyvfczy9g96k927clcj8";
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

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xsl
    gettext
    gobject-introspection
    gtk-doc
    libxslt
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gcr
    glib
    glib-networking
    gtk3
    icu
    json-glib
    kerberos
    librest
    libsecret
    libsoup
    webkitgtk
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/GnomeOnlineAccounts";
    description = "Single sign-on framework for GNOME";
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
  };
}
