{ fetchurl, stdenv, pkgconfig, gnome3, intltool, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, libcanberra_gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libgudev, libwacom, libxslt, libtool, networkmanager
, docbook_xsl, docbook_xsl_ns, wrapGAppsHook, ibus, xkeyboard_config, tzdata }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  buildInputs = with gnome3;
    [ intltool pkgconfig ibus gtk glib gsettings_desktop_schemas networkmanager
      libnotify gnome_desktop lcms2 libXtst libxkbfile libpulseaudio
      libcanberra_gtk3 upower colord libgweather xkeyboard_config
      polkit geocode_glib geoclue2 librsvg xf86_input_wacom udev libgudev libwacom libxslt
      libtool docbook_xsl docbook_xsl_ns wrapGAppsHook gnome_themes_standard ];

  postPatch = ''
    substituteInPlace plugins/datetime/tz.h --replace /usr/share/zoneinfo/zone.tab ${tzdata}/share/zoneinfo/zone.tab
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
