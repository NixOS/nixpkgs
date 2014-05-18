{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus_glib, json_glib, upower
, libxslt, intltool, makeWrapper, systemd, xorg }:


stdenv.mkDerivation rec {
  name = "gnome-session-3.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/3.12/${name}.tar.xz";
    sha256 = "fa308771ac18bc5f77e5a5be3b2d93df1625168cb40167c1dfa898e9006e25d3";
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
  };

}
