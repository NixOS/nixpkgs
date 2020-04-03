{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui, xfconf, gtk2, libunique }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-notes-plugin";
  ver_maj = "1.7";
  ver_min = "7";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "05sjbwgch1j93m3r23ksbjnpfk11sf7xjmbb9pm5vl3snc2s3fm7";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel xfconf gtk2 libunique ];

  meta = {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Sticky notes plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
    broken = true;
  };
}
