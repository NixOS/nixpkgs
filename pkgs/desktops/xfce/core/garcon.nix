{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util }:

stdenv.mkDerivation rec {
  p_name  = "garcon";
  ver_maj = "0.2";
  ver_min = "1";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1xq14wayk07cil04yhrdkjhacz9dbldcl9i59sbrgrgznaw49dj8";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
