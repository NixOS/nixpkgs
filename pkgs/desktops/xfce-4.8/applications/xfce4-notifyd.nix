{ stdenv, fetchurl, intltool, pkgconfig, gtk, xfce }:

stdenv.mkDerivation rec {
  name = "xfce4-notifyd-0.2.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/xfce4-notifyd/0.2/${name}.tar.bz2";
    sha256 = "0s4ilc36sl5k5mg5727rmqims1l3dy5pwg6dk93wyjqnqbgnhvmn";
  };

  buildInputs = [ intltool pkgconfig gtk xfce.libxfce4util xfce.libxfce4ui xfce.xfconf ];

  meta = {
    homepage = http://goodies.xfce.org/projects/applications/xfce4-notifyd;
    description = "The Xfce Notify Daemon";
    platforms = stdenv.lib.platforms.linux;
  };
}
