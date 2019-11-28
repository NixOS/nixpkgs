{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, glib, gettext, cinnamon-desktop, intltool, libxslt, gtk3, libnotify,
gnome-menus, libxml2, systemd, upower, cinnamon-settings-daemon, colord, polkit, ibus, libcanberra_gtk3, libpulseaudio, isocodes, kerberos,
libxkbfile, cinnamon-menus, dbus-glib, libgnomekbd, libxklavier, networkmanager, libwacom, gnome3, libtool, wrapGAppsHook, tzdata, glibc }:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1rxm5n2prh182rxvjs7psxgjddikrjr8492j22060gmyvq55n7kc";
  };

  # TODO: fix network manager integration
 configureFlags = [ "--enable-systemd" "--disable-networkmanager" "--disable-modemmanager" ];

 # patches = [ ./region.patch ];

 buildInputs = [ gtk3 glib cinnamon-desktop libnotify cinnamon-menus libxml2 dbus-glib systemd polkit libgnomekbd libxklavier /* networkmanager */ colord cinnamon-settings-daemon libwacom gnome3.gnome-online-accounts tzdata ];

 #buildInputs = [
  #  glib gtk3 cinnamon-desktop
  #  libnotify gnome-menus libxml2 systemd
  #  upower cinnamon-settings-daemon colord
  #  polkit ibus libcanberra_gtk3 libpulseaudio
  #  isocodes kerberos libxkbfile ];

  preConfigurePhases = "confFixPhase";

  /* ./panels/datetime/test-timezone.c:4:#define TZ_DIR "/usr/share/zoneinfo/"
  ./panels/datetime/tz.h:32:#  define TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"
  ./panels/datetime/tz.h:34:#  define TZ_DATA_FILE "/usr/share/lib/zoneinfo/tab/zone_sun.tab" */


  confFixPhase = ''
    patchShebangs ./autogen.sh
    sed 's|TZ_DIR "/usr/share/zoneinfo/"|TZ_DIR "${tzdata}/share/zoneinfo/"|g' -i ./panels/datetime/test-timezone.c
    sed 's|TZ_DATA_FILE "/usr/share/zoneinfo/zone.tab"|TZ_DATA_FILE "${tzdata}/share/zoneinfo/zone.tab"|g' -i ./panels/datetime/tz.h
    sed 's|"/usr/share/i18n/locales/"|"${glibc}/share/i18n/locales/"|g' -i panels/datetime/test-endianess.c
    '';

  autoreconfPhase = ''
    NOCONFIGURE=1 bash ./autogen.sh
    '';


  preBuildPhases = "hackyDatetimeBackward";
  preInstallPhases = "undoHackyDatetimeBackward";

  # it needs to have access to that file, otherwise we can't run tests after build

  hackyDatetimeBackward = ''
    mkdir -p $out/share/cinnamon-control-center/
    ln -s $PWD/panels/datetime $out/share/cinnamon-control-center/
    '';

  undoHackyDatetimeBackward = ''
    rm -rfv $out
    '';

  nativeBuildInputs = [ pkgconfig autoreconfHook wrapGAppsHook gettext /*gnome_common*/ intltool libxslt libtool ];

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Cinnamon control center" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
