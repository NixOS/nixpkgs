{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-icon-theme";
  ver_maj = "4.4";
  ver_min = "3";

  src = fetchurl {
    url = "mirror://xfce/src/art/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1yk6rx3zr9grm4jwpjvqdkl13pisy7qn1wm5cqzmd2kbsn96cy6l";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Icons for Xfce";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
