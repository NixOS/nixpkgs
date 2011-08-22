{ stdenv, fetchurl, pkgconfig, intltool, URI, glib, gtk, libxfce4util }:

stdenv.mkDerivation rec {
  name = "exo-0.6.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/exo/0.6/${name}.tar.bz2";
    sha1 = "2486f12c814630068665e22cdf417f0f0f05dab1";
  };

  buildInputs =
    [ pkgconfig intltool URI glib gtk libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/projects/exo;
    description = "Application library for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
