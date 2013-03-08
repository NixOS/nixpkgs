{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util }:

stdenv.mkDerivation rec {
  p_name  = "garcon";
  ver_maj = "0.2";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0v7pkvxcayi86z4f173z5l7w270f3g369sa88z59w0y0p7ns7ph2";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "GPLv2+";
  };
}
