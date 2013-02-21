{ stdenv, fetchurl, pkgconfig, glib, intltool }:

stdenv.mkDerivation rec {
  p_name  = "libxfce4util";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "13k0wwbbqvdmbj4xmk4nxdlgvrdgr5y6r3dk380mzfw053hzwy89";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig glib intltool ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic utility non-GUI functions for Xfce";
    license = "bsd";
  };
}
