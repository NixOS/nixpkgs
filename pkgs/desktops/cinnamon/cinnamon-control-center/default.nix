{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, glib, gettext, cinnamon-desktop, intltool, libxslt, gtk3, libnotify,
gnome-menus, libxml2, systemd, upower, cinnamon-settings-daemon, colord, polkit, ibus, libcanberra_gtk3, libpulseaudio, isocodes, kerberos,
libxkbfile}:

stdenv.mkDerivation rec {
  pname = "cinnamon-control-center";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1rxm5n2prh182rxvjs7psxgjddikrjr8492j22060gmyvq55n7kc";
  };

 configureFlags = [ "--enable-systemd" "--disable-update-mimedb" ];

 # patches = [ ./region.patch ];

 buildInputs = [
    glib gtk3 cinnamon-desktop
    libnotify gnome-menus libxml2 systemd
    upower cinnamon-settings-daemon colord
    polkit ibus libcanberra_gtk3 libpulseaudio
    isocodes kerberos libxkbfile ];

  nativeBuildInputs = [ pkgconfig autoreconfHook gettext /*gnome_common*/ intltool libxslt ];

  preBuild = "patchShebangs ./scripts";

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Cinnamon control center" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
