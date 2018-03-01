{ fetchurl, stdenv, pkgconfig, gnome3, glib, dbus-glib, json-glib, upower
, libxslt, intltool, makeWrapper, systemd, xorg, epoxy }:

stdenv.mkDerivation rec {
  name = "gnome-session-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-session/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "d9414b368db982d3837ca106e64019f18e6cdd5b13965bea6c7d02ddf5103708";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-session"; attrPath = "gnome3.gnome-session"; };
  };

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
