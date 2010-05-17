{ stdenv, fetchurl
, pkgconfig
, glib
}:

stdenv.mkDerivation {
  name = "libxfce4util-4.6.1";
  src = fetchurl {
    url = http://www.xfce.org/archive/xfce-4.6.1/src/libxfce4util-4.6.1.tar.bz2;
    sha256 = "0sy1222s0cq8zy2ankrp1747b6fg5jjahxrddih4gxc97iyxrv6f";
  };

  buildInputs = [ pkgconfig glib ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic utility non-GUI functions for Xfce";
    license = "GPLv2";
  };
}
