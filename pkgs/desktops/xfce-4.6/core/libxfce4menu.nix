{ stdenv, fetchurl, pkgconfig, glib, intltool, gtk, libxfce4util }:

stdenv.mkDerivation rec {
  name = "libxfce4menu-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce-4.6.2/src/${name}.tar.bz2";
    sha1 = "32a85c1ad31360347d5a2f240c4ddc08b444d124";
  };

  buildInputs = [ pkgconfig glib intltool gtk libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "LGPLv2+";
  };
}
