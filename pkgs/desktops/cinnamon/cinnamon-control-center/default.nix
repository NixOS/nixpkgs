{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, libgnomekbd
, libxklavier
, networkmanager
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
  version = "5.4.4";

  patches = [
    # Add missing gio-unix-2.0 dependency, can be removed on next update
    # https://github.com/linuxmint/cinnamon-control-center/pull/294
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon-control-center/commit/7f5ba6e7a691547840f8482445c09c729e10a397.patch";
      sha256 = "sha256-xcf/O/DfhOvCpWJl0XZD+xAwWs4STAeCaFMZ9Lftv2w=";
    })
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-c2JbRAMcTnqaqt8MXQl4AxnENVmfYyHcCteWBWQUSO0=";
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

  # it needs to have access to that file, otherwise we can't run tests after build

  preBuild = ''
    mkdir -p $out/share/cinnamon-control-center/
    ln -s $PWD/panels/datetime $out/share/cinnamon-control-center/
  '';

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
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
