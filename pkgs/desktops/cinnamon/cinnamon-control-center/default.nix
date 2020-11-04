{ stdenv
, fetchFromGitHub
, pkgconfig
, autoreconfHook
, glib
, gettext
, cinnamon-desktop
, intltool
, gtk3
, libnotify
, gnome-menus
, libxml2
, systemd
, upower
, gnome-online-accounts
, cinnamon-settings-daemon
, colord
, polkit
, ibus
, libpulseaudio
, isocodes
, kerberos
, libxkbfile
, cinnamon-menus
, dbus-glib
, libgnomekbd
, libxklavier
, networkmanager
, libwacom
, gnome3
, libtool
, wrapGAppsHook
, tzdata
, glibc
, libnma
, modemmanager
, xorg
, gdk-pixbuf
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0ls2ys4x6qqp0j727c4n7a6319m4k1qsy1ybxkfzlzgf750v9xda";
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
    patchShebangs ./autogen.sh
    sed 's|TZ_DIR "/usr/share/zoneinfo/"|TZ_DIR "${tzdata}/share/zoneinfo/"|g' -i ./panels/datetime/test-timezone.c
    sed 's|TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"|TZ_DATA_FILE "${tzdata}/share/zoneinfo/zone.tab"|g' -i ./panels/datetime/tz.h
    sed 's|"/usr/share/i18n/locales/"|"${glibc}/share/i18n/locales/"|g' -i panels/datetime/test-endianess.c
  '';

  autoreconfPhase = ''
    NOCONFIGURE=1 bash ./autogen.sh
  '';

  # it needs to have access to that file, otherwise we can't run tests after build

  preBuild = ''
    mkdir -p $out/share/cinnamon-control-center/
    ln -s $PWD/panels/datetime $out/share/cinnamon-control-center/
  '';

  preInstall = ''
    rm -rfv $out
  '';

  doCheck = true;

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
    wrapGAppsHook
    gettext
    intltool
    libtool
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-control-center";
    description = "A collection of configuration plugins used in cinnamon-settings";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
