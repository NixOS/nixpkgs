{ fetchurl, stdenv, pkgconfig, gnome3, ibus, intltool, upower, wrapGAppsHook
, libcanberra_gtk3, accountsservice, libpwquality, libpulseaudio
, gdk_pixbuf, librsvg, libnotify, libgudev
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk
, cracklib, python, libkrb5, networkmanagerapplet, networkmanager
, libwacom, samba, shared_mime_info, tzdata, libtool
, docbook_xsl, docbook_xsl_ns, modemmanager, clutter, clutter_gtk
, fontconfig, sound-theme-freedesktop, grilo }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [
    pkgconfig intltool wrapGAppsHook libtool libxslt docbook_xsl docbook_xsl_ns
    shared_mime_info
  ];

  buildInputs = with gnome3; [
    ibus gtk glib glib_networking upower gsettings_desktop_schemas
    libxml2 gnome_desktop gnome_settings_daemon polkit libgtop
    gnome_online_accounts libsoup colord libpulseaudio fontconfig colord-gtk
    accountsservice libkrb5 networkmanagerapplet libwacom samba libnotify
    grilo libpwquality cracklib vino libcanberra_gtk3 libgudev
    gdk_pixbuf defaultIconTheme librsvg clutter clutter_gtk
    networkmanager modemmanager gnome-bluetooth tracker
  ];

  preBuild = ''
    substituteInPlace panels/datetime/tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"

    substituteInPlace panels/region/cc-region-panel.c --replace "gkbd-keyboard-display" "${gnome3.libgnomekbd}/bin/gkbd-keyboard-display"

    # hack to make test-endianess happy
    mkdir -p $out/share/locale
    substituteInPlace panels/datetime/test-endianess.c --replace "/usr/share/locale/" "$out/share/locale/"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:${sound-theme-freedesktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
    )
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "gnome-control-center" "$out/bin/gnome-control-center"
    done
  '';

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
