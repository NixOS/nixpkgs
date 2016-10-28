{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus_glib, json_glib, upower
, libxslt, intltool, makeWrapper, systemd, xorg }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = "--enable-systemd";

  buildInputs = with gnome3;
    [ pkgconfig glib gnome_desktop gtk dbus_glib json_glib libxslt
      gnome3.gnome_settings_daemon xorg.xtrans gnome3.defaultIconTheme
      gsettings_desktop_schemas upower intltool gconf makeWrapper systemd ];

  # FIXME: glib binaries shouldn't be in .dev!
  preFixup = ''
    for desktopFile in $(grep -rl "Exec=gnome-session" $out/share)
    do
      echo "Patching gnome-session path in: $desktopFile"
      sed -i "s,^Exec=gnome-session,Exec=$out/bin/gnome-session --debug," $desktopFile
    done
    wrapProgram "$out/bin/gnome-session" \
      --prefix PATH : "${glib.dev}/bin" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome3.gnome_shell}/share" \
      --suffix XDG_CONFIG_DIRS : "${gnome3.gnome_settings_daemon}/etc/xdg"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
