{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util, libxfce4ui, gtk }:
let
  p_name  = "garcon";
  ver_maj = "0.4";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/xfce/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "0wm9pjbwq53s3n3nwvsyf0q8lbmhiy2ln3bn5ncihr9vf5cwhzbq";
  };

  outputs = [ "out" "dev" ];
  patches = [ ./garcon-10967.patch ./garcon-12700.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool glib libxfce4util gtk libxfce4ui ];

  meta = with stdenv.lib; {
    homepage = https://www.xfce.org/;
    description = "Xfce menu support library";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
