{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus_glib, json_glib, upower
, libxslt, intltool, makeWrapper, systemd }:


stdenv.mkDerivation rec {
  name = "gnome-session-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/3.10/${name}.tar.xz";
    sha256 = "1k59yss7r748nvr0cdjrqmx0zy26b93rfn66lsdg9fz60x77087n";
  };

  configureFlags = "--enable-systemd";

  buildInputs = with gnome3;
    [ pkgconfig glib gnome_desktop gtk dbus_glib json_glib libxslt 
      gnome3.gnome_settings_daemon
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
