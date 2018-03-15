{ stdenv, fetchurl, pkgconfig, vala, glib, libxslt, gtk, wrapGAppsHook
, webkitgtk, json-glib, rest, libsecret, dbus-glib, gtk-doc
, telepathy-glib, gettext, dbus_libs, icu, glib-networking
, libsoup, docbook_xsl, docbook_xsl_ns, gnome3, gcr, kerberos
}:

let
  pname = "gnome-online-accounts";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "035lmm21imr7ddpzffqabv53g3ggjscmqvlzy3j1qkv00zrlxg47";
  };

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
    pkgconfig vala gettext wrapGAppsHook
    libxslt docbook_xsl docbook_xsl_ns gtk-doc
  ];
  buildInputs = [
    glib gtk webkitgtk json-glib rest libsecret dbus-glib telepathy-glib glib-networking icu libsoup
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
