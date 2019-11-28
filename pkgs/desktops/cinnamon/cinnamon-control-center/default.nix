{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, glib, gettext, cinnamon-desktop, intltool, libxslt, gtk3, libnotify,
gnome-menus, libxml2, systemd, upower, cinnamon-settings-daemon, colord, polkit, ibus, libcanberra_gtk3, libpulseaudio, isocodes, kerberos,
libxkbfile, cinnamon-menus, dbus-glib, libgnomekbd, libxklavier, networkmanager, libwacom, gnome3 }:

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
 configureFlags = [ "--enable-systemd" "--disable-update-mimedb" "--disable-networkmanager" "--disable-modemmanager" ];

 # patches = [ ./region.patch ];

 buildInputs = [ gtk3 glib cinnamon-desktop libnotify cinnamon-menus libxml2 dbus-glib systemd polkit libgnomekbd libxklavier /* networkmanager */ colord cinnamon-settings-daemon libwacom gnome3.gnome-online-accounts ];

 #buildInputs = [
  #  glib gtk3 cinnamon-desktop
  #  libnotify gnome-menus libxml2 systemd
  #  upower cinnamon-settings-daemon colord
  #  polkit ibus libcanberra_gtk3 libpulseaudio
  #  isocodes kerberos libxkbfile ];

  nativeBuildInputs = [ pkgconfig autoreconfHook gettext /*gnome_common*/ intltool libxslt ];

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Cinnamon control center" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
