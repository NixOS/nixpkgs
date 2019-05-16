{ stdenv, fetchurl, pkgconfig, glib, intltool }:
let
  p_name  = "libxfce4util";
  ver_maj = "4.12";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "07c8r3xwx5is298zk77m3r784gmr5y4mh8bbca5zdjqk5vxdwsw7";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib intltool ];

  meta = {
    homepage = https://www.xfce.org/;
    description = "Basic utility non-GUI functions for Xfce";
    license = "bsd";
    platforms = stdenv.lib.platforms.linux;
  };
}
