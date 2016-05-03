{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  p_name  = "gtk-xfce-engine";
  ver_maj = "3.2";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1va71f3gpl8gikfkmqsd5ikgp7qj8b64jii2l98g1ylnv8xrqp47";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
