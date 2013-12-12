 
{stdenv, fetchurl, pkgconfig, autoreconfHook, glib, gettext, gnome_common,
systemd, cinnamon-desktop, intltool, libxslt, gtk3, libnotify, gnome-menus, libxml2,
upower, cinnamon-settings-daemon, colord, polkit, ibus, pulseaudio, libcanberra_gtk3,
isocodes, networkmanager, kerberos, libxkbfile 
}:

let
  version = "2.0.9";
in
stdenv.mkDerivation {
  name = "cinnamon-control-center-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-control-center/archive/${version}.tar.gz";
    sha256 = "63bb179a50d5f873ed1c19de97966592eedbc055ce2829e4298223a75fc33b4e" ;
  };


  configureFlags = "-enable-systemd --disable-static --disable-update-mimedb" ;

  patches = [ ./region.patch];

  buildInputs = [
    pkgconfig autoreconfHook
    glib gettext gnome_common
    systemd intltool
    libxslt cinnamon-desktop gtk3 libnotify
    gnome-menus libxml2 upower cinnamon-settings-daemon
    colord polkit ibus pulseaudio libcanberra_gtk3
    isocodes networkmanager kerberos libxkbfile
   ];

  preBuild = "patchShebangs ./scripts";


  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "The cinnamon control center" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

