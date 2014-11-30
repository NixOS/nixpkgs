{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus_glib, json_glib, upower
, libxslt, intltool, makeWrapper, systemd, xorg }:


stdenv.mkDerivation rec {
  name = "gnome-session-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${gnome3.version}/${name}.tar.xz";
    sha256 = "b1e6e805478b863eda58e61ecd0e13961f63dd76e2d49692affc5a1d00f2c184";
  };

  configureFlags = "--enable-systemd";

  buildInputs = with gnome3;
    [ pkgconfig glib gnome_desktop gtk dbus_glib json_glib libxslt 
      gnome3.gnome_settings_daemon xorg.xtrans
      gsettings_desktop_schemas upower intltool gconf makeWrapper systemd ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-session" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
