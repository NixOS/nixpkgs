{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  p_name  = "xfwm4-themes";
  ver_maj = "4.10";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/art/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0xfmdykav4rf6gdxbd6fhmrfrvbdc1yjihz7r7lba0wp1vqda51j";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  meta = with stdenv.lib; {
    homepage = http://www.xfce.org/;
    description = "Themes for Xfce";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
