{ stdenv, fetchurl, pkgconfig, vala, glib, libxslt, gtk, wrapGAppsHook
, webkitgtk, json-glib, rest, libsecret, dbus-glib, gnome-common, gtk-doc
, telepathy-glib, intltool, dbus_libs, icu, glib-networking
, libsoup, docbook_xsl_ns, docbook_xsl, gnome3, gcr, kerberos
}:

stdenv.mkDerivation rec {
  name = "gnome-online-accounts-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "49f8760d86fe33057eaeeb4f1667bc7f6163e428591e7aed9575563be10b17d1";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-online-accounts"; attrPath = "gnome3.gnome-online-accounts"; };
  };

  NIX_CFLAGS_COMPILE = "-I${dbus-glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  outputs = [ "out" "man" "dev" "devdoc" ];

  configureFlags = [
    "--enable-media-server"
    "--enable-kerberos"
    "--enable-lastfm"
    "--enable-todoist"
    "--enable-gtk-doc"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig vala gnome-common intltool wrapGAppsHook
    libxslt docbook_xsl_ns docbook_xsl gtk-doc
  ];
  buildInputs = [
    glib gtk webkitgtk json-glib rest libsecret dbus-glib telepathy-glib glib-networking icu libsoup
    gcr kerberos
  ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
