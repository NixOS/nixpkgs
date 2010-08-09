{ stdenv, fetchurl, pkgconfig, intltool, URI, glib, gtk, libxfce4util
, enableHAL ? true, hal, dbus_glib }:

stdenv.mkDerivation rec {
  name = "exo-0.3.107";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha256 = "18z2xmdl577r60ln2waai10dd7i384k0bxrmf7gchrxd9c9aq4ha";
  };

  buildInputs =
    [ pkgconfig intltool URI glib gtk libxfce4util ] ++
    stdenv.lib.optionals enableHAL [ hal dbus_glib ];

  meta = {
    homepage = http://www.xfce.org/projects/exo;
    description = "Application library for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
