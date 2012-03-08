{ stdenv, fetchurl, pkgconfig, dbus_glib, cairo, dbus, gtk, pango, atk, libXau, libXtst, inputproto
, intltool, libglade, startup_notification, GConf, upower }:

stdenv.mkDerivation {
  name = "gnome-session-2.32.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-session/2.32/gnome-session-2.32.1.tar.bz2;
    sha256 = "0sk8qclarpar27va1ahzwjh2wsafys0xsdjzdg7cgygw6gj3rn92";
  };

  buildInputs =
    [ dbus_glib gtk libXau libXtst inputproto libglade startup_notification
      GConf upower
    ];
  buildNativeInputs = [ pkgconfig intltool ];
}
