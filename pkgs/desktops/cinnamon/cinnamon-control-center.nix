
{ stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common, cinnamon-desktop, intltool, libxslt, gtk3, libnotify,
gnome-menus, libxml2, systemd, upower, cinnamon-settings-daemon, colord, polkit, ibus, libcanberra_gtk3, pulseaudio, isocodes, kerberos,
libxkbfile}:

let
  version = "2.0.9";
in
stdenv.mkDerivation {
  name = "cinnamon-control-center-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-control-center/archive/${version}.tar.gz";
    sha256 = "0kivqdgsf8w257j2ja6fap0dpvljcnb9gphr3knp7y6ma2d1gfv3";
  };

 configureFlags = "--enable-systemd --disable-update-mimedb" ;

  patches = [ ./region.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    intltool libxslt gtk3 cinnamon-desktop
    libnotify gnome-menus libxml2 systemd
    upower cinnamon-settings-daemon colord
    polkit ibus libcanberra_gtk3 pulseaudio
    isocodes kerberos libxkbfile ];

  preBuild = "patchShebangs ./scripts";

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];

    broken = true;
  };
}
