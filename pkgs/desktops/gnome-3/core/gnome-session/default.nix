{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus-glib, json-glib, upower
, libxslt, intltool, makeWrapper, systemd, xorg, epoxy }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = "--enable-systemd";

  buildInputs = with gnome3;
    [ pkgconfig glib gnome-desktop gtk dbus-glib json-glib libxslt
      gnome3.gnome-settings-daemon xorg.xtrans gnome3.defaultIconTheme
      gsettings-desktop-schemas upower intltool gconf makeWrapper systemd
      epoxy
    ];

  # FIXME: glib binaries shouldn't be in .dev!
  preFixup = ''
    for desktopFile in $(grep -rl "Exec=gnome-session" $out/share)
    do
      echo "Patching gnome-session path in: $desktopFile"
      sed -i "s,^Exec=gnome-session,Exec=$out/bin/gnome-session," $desktopFile
    done
    wrapProgram "$out/bin/gnome-session" \
      --prefix PATH : "${glib.dev}/bin" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --suffix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
      --suffix XDG_DATA_DIRS : "${gnome3.gnome-shell}/share" \
      --suffix XDG_CONFIG_DIRS : "${gnome3.gnome-settings-daemon}/etc/xdg"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
