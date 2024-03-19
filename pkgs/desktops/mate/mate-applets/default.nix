{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, dbus-glib
, glib
, gtk3
, gtksourceview4
, gucharmap
, libmateweather
, libnl
, libwnck
, libgtop
, libxml2
, libnotify
, mate-desktop
, mate-panel
, polkit
, upower
, wirelesstools
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-applets";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "G2vva9XTJvudyCj/kQ5LG5KUtGYMMR3ByQMQ/Zw1ZoY=";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    gtk3
    gtksourceview4
    gucharmap
    hicolor-icon-theme
    libgtop
    libmateweather
    libnl
    libnotify
    libwnck
    libxml2
    mate-desktop # for org.mate.lockdown
    mate-panel
    polkit
    upower
    wirelesstools
  ];

  configureFlags = [ "--enable-suid=no" "--enable-in-process" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Applets for use with the MATE panel";
    mainProgram = "mate-cpufreq-selector";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
