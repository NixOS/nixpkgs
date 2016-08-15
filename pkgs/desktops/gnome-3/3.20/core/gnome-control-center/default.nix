{ fetchurl, stdenv, pkgconfig, gnome3, ibus, intltool, upower, makeWrapper
, libcanberra, libcanberra_gtk3, accountsservice, libpwquality, libpulseaudio
, gdk_pixbuf, librsvg, libxkbfile, libnotify, libgudev
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk
, cracklib, python, libkrb5, networkmanagerapplet, networkmanager
, libwacom, samba, shared_mime_info, tzdata, icu, libtool, udev
, docbook_xsl, docbook_xsl_ns, modemmanager, clutter, clutter_gtk
, fontconfig, sound-theme-freedesktop, grilo }:

# http://ftp.gnome.org/pub/GNOME/teams/releng/3.10.2/gnome-suites-core-3.10.2.modules
# TODO: bluetooth, wacom, printers

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs =
    [ gnome3.gnome_themes_standard gnome3.libgnomekbd ];

  # https://bugzilla.gnome.org/show_bug.cgi?id=752596
  enableParallelBuilding = false;

  buildInputs = with gnome3;
    [ pkgconfig intltool ibus gtk glib upower libcanberra gsettings_desktop_schemas
      libxml2 gnome_desktop gnome_settings_daemon polkit libxslt libgtop gnome-menus
      gnome_online_accounts libsoup colord libpulseaudio fontconfig colord-gtk libpwquality
      accountsservice libkrb5 networkmanagerapplet libwacom samba libnotify libxkbfile
      shared_mime_info icu libtool docbook_xsl docbook_xsl_ns gnome3.grilo
      gdk_pixbuf gnome3.defaultIconTheme librsvg clutter clutter_gtk
      gnome3.vino udev libcanberra_gtk3 libgudev
      networkmanager modemmanager makeWrapper gnome3.gnome-bluetooth grilo ];

  preBuild = ''
    substituteInPlace panels/datetime/tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"

    # hack to make test-endianess happy
    mkdir -p $out/share/locale
    substituteInPlace panels/datetime/test-endianess.c --replace "/usr/share/locale/" "$out/share/locale/"
  '';

  preFixup = with gnome3; ''
    wrapProgram $out/bin/gnome-control-center \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:${sound-theme-freedesktop}/share:$out/share:$out/share/gnome-control-center:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
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
