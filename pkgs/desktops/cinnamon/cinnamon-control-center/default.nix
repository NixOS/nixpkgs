{ lib, stdenv
, fetchFromGitHub
, pkg-config
, glib
, gettext
, cinnamon-desktop
, gtk3
, libnotify
, libxml2
, gnome-online-accounts
, cinnamon-settings-daemon
, colord
, polkit
, libxkbfile
, cinnamon-menus
, dbus-glib
, libgnomekbd
, libxklavier
, networkmanager
, libwacom
, gnome3
, wrapGAppsHook
, tzdata
, glibc
, libnma
, modemmanager
, xorg
, gdk-pixbuf
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
  version = "4.8.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-vALThDY0uN9bV7b1fga3MK7b2/l5uL33+B2x6oSLPRE=";
  };

  buildInputs = [
    gtk3
    glib
    cinnamon-desktop
    libnotify
    cinnamon-menus
    libxml2
    dbus-glib
    polkit
    libgnomekbd
    libxklavier
    colord
    cinnamon-settings-daemon
    libwacom
    gnome-online-accounts
    tzdata
    networkmanager
    libnma
    modemmanager
    xorg.libXxf86misc
    xorg.libxkbfile
    gdk-pixbuf
  ];

  /* ./panels/datetime/test-timezone.c:4:#define TZ_DIR "/usr/share/zoneinfo/"
  ./panels/datetime/tz.h:32:#  define TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"
  ./panels/datetime/tz.h:34:#  define TZ_DATA_FILE "/usr/share/lib/zoneinfo/tab/zone_sun.tab" */

  postPatch = ''
    sed 's|TZ_DIR "/usr/share/zoneinfo/"|TZ_DIR "${tzdata}/share/zoneinfo/"|g' -i ./panels/datetime/test-timezone.c
    sed 's|TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"|TZ_DATA_FILE "${tzdata}/share/zoneinfo/zone.tab"|g' -i ./panels/datetime/tz.h
    sed 's|"/usr/share/i18n/locales/"|"${glibc}/share/i18n/locales/"|g' -i panels/datetime/test-endianess.c
  '';

  # it needs to have access to that file, otherwise we can't run tests after build

  preBuild = ''
    mkdir -p $out/share/cinnamon-control-center/
    ln -s $PWD/panels/datetime $out/share/cinnamon-control-center/
  '';

  mesonFlags = [
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  preInstall = ''
    rm -r $out
  '';

  # the only test is wacom-calibrator and it seems to need an xserver and prob more services aswell
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook
    gettext
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "A collection of configuration plugins used in cinnamon-settings";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
