{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, glib
, gettext
, cinnamon-desktop
, gtk3
, libnotify
, libxml2
, gnome-online-accounts
, colord
, polkit
, libxkbfile
, cinnamon-menus
, libgnomekbd
, libxklavier
, networkmanager
, libgudev
, libwacom
, gnome
, wrapGAppsHook
, tzdata
, glibc
, libnma
, modemmanager
, xorg
, gdk-pixbuf
, meson
, ninja
, cinnamon-translations
, python3
, upower
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-zkJkZagZBt6JMiC/HLsyP9+qVLtTszumOk3PKt18X4Y=";
  };

  buildInputs = [
    gtk3
    glib
    cinnamon-desktop
    libnotify
    cinnamon-menus
    libxml2
    polkit
    libgnomekbd
    libxklavier
    colord
    libgudev
    libwacom
    gnome-online-accounts
    tzdata
    networkmanager
    libnma
    modemmanager
    xorg.libXxf86misc
    xorg.libxkbfile
    gdk-pixbuf
    upower
  ];

  /* ./panels/datetime/test-timezone.c:4:#define TZ_DIR "/usr/share/zoneinfo/"
    ./panels/datetime/tz.h:32:#  define TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"
    ./panels/datetime/tz.h:34:#  define TZ_DATA_FILE "/usr/share/lib/zoneinfo/tab/zone_sun.tab" */

  postPatch = ''
    sed 's|TZ_DIR "/usr/share/zoneinfo/"|TZ_DIR "${tzdata}/share/zoneinfo/"|g' -i ./panels/datetime/test-timezone.c
    sed 's|TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"|TZ_DATA_FILE "${tzdata}/share/zoneinfo/zone.tab"|g' -i ./panels/datetime/tz.h
    sed 's|"/usr/share/i18n/locales/"|"${glibc}/share/i18n/locales/"|g' -i panels/datetime/test-endianess.c

    patchShebangs meson_install_schemas.py
  '';

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook
    gettext
    python3
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "A collection of configuration plugins used in cinnamon-settings";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
