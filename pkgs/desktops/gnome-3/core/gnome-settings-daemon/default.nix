{ fetchurl, stdenv, pkgconfig, gnome3, intltool, glib, libnotify, lcms2, libXtst
, libxkbfile, libpulseaudio, libcanberra-gtk3, upower, colord, libgweather, polkit
, geoclue2, librsvg, xf86_input_wacom, udev, libgudev, libwacom, libxslt, libtool, networkmanager
, docbook_xsl, docbook_xsl_ns, wrapGAppsHook, ibus, xkeyboard_config, tzdata }:

stdenv.mkDerivation rec {
  name = "gnome-settings-daemon-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-settings-daemon/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "5a3d156b35e03fa3c28fddd0321f6726082a711973dee2af686370faae2e75e4";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-settings-daemon"; attrPath = "gnome3.gnome-settings-daemon"; };
  };

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  buildInputs = with gnome3;
    [ intltool pkgconfig ibus gtk glib gsettings-desktop-schemas networkmanager
      libnotify gnome-desktop lcms2 libXtst libxkbfile libpulseaudio
      libcanberra-gtk3 upower colord libgweather xkeyboard_config
      polkit geocode-glib geoclue2 librsvg xf86_input_wacom udev libgudev libwacom libxslt
      libtool docbook_xsl docbook_xsl_ns wrapGAppsHook gnome-themes-standard ];

  postPatch = ''
    substituteInPlace plugins/datetime/tz.h --replace /usr/share/zoneinfo/zone.tab ${tzdata}/share/zoneinfo/zone.tab
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
