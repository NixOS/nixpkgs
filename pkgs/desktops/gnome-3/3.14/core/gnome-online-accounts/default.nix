{ stdenv, fetchurl, pkgconfig, glib, libxslt, gtk, makeWrapper
, webkitgtk, json_glib, rest, libsecret, dbus_glib, gnome_common
, telepathy_glib, intltool, dbus_libs, icu, autoreconfHook
, libsoup, docbook_xsl_ns, docbook_xsl, gnome3
}:

stdenv.mkDerivation rec {
  name = "gnome-online-accounts-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/${gnome3.version}/${name}.tar.xz";
    sha256 = "341a2c79cd26770ccbf4476f7ce7222cfe026f442cfbd05dc7f7612f7b30dae9";
  };

  NIX_CFLAGS_COMPILE = "-I${dbus_glib}/include/dbus-1.0 -I${dbus_libs}/include/dbus-1.0";

  enableParallelBuilding = true;

  preAutoreconf = ''
    sed '/disable-settings/d' -i configure.ac
  '';

  buildInputs = [ pkgconfig glib libxslt gtk webkitgtk json_glib rest gnome_common makeWrapper
                  libsecret dbus_glib telepathy_glib intltool icu libsoup docbook_xsl_ns docbook_xsl];

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
