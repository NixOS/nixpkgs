{ stdenv, fetchurl, pkgconfig, intltool, glib, gtk, libxfce4util
, libxfce4ui, garcon, xfconf }:
let
  p_name  = "xfce4-appfinder";
  ver_maj = "4.12";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0ry5hin8xhgnkmm9vs7jq8blk1cnbyr0s18nm1j6nsm7360abm1a";
  };

  buildInputs =
    [ pkgconfig intltool glib gtk libxfce4util libxfce4ui garcon xfconf ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://docs.xfce.org/xfce/xfce4-appfinder/;
    description = "Xfce application finder, a tool to locate and launch programs on your system";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
  };
}

