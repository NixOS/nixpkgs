{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus_glib, json_glib, upower
, libxslt, intltool, makeWrapper, systemd, xorg }:


stdenv.mkDerivation rec {
  name = "gnome-session-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${gnome3.version}/${name}.tar.xz";
    sha256 = "17d9zryq13ajmai6fqynpfgghms52sj9h756f086i7fxbr2nsm4v";
  };

  configureFlags = "--enable-systemd";

  buildInputs = with gnome3;
    [ pkgconfig glib gnome_desktop gtk dbus_glib json_glib libxslt 
      gnome3.gnome_settings_daemon xorg.xtrans gnome3.defaultIconTheme
      gsettings_desktop_schemas upower intltool gconf makeWrapper systemd ];

  preFixup = ''
    wrapProgram "$out/bin/gnome-session" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
