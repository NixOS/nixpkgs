{ stdenv, fetchurl, pkgconfig, intltool, gtk, libxfce4util, libxfcegui4
, libwnck, exo, libstartup_notification }:

stdenv.mkDerivation rec {
  name = "xfce4-panel-4.6.4";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "d2b310c036be84ed9886c06ae35b7a1a8eabfcb8";
  };

  buildInputs =
    [ pkgconfig intltool gtk libxfce4util exo libwnck
      libstartup_notification
    ];

  propagatedBuildInputs = [ libxfcegui4 ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce panel";
    license = "GPLv2+";
  };
}
