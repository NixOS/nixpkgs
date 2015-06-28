{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, libxfce4ui, gtk }:

stdenv.mkDerivation rec {
  p_name  = "garcon";
  ver_maj = "0.4";
  ver_min = "0";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0wm9pjbwq53s3n3nwvsyf0q8lbmhiy2ln3bn5ncihr9vf5cwhzbq";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  buildInputs = [ pkgconfig intltool glib libxfce4util gtk libxfce4ui ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
