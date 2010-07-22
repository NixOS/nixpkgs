{ fetchurl, stdenv, pkgconfig, clutter, gtk }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-0.10.2";

  src = fetchurl {
    url = "http://source.clutter-project.org/sources/clutter-gtk/0.10/${name}.tar.bz2";
    sha256 = "1jdhhqin4wi8gk6i1m701vrhm6lrvywq3q3yy88ph8yj8h6z4any";
  };

  buildInputs = [ pkgconfig clutter gtk ];

  preConfigure = "export V=1";

  meta = {
    description = "Clutter-GTK";

    homepage = http://www.clutter-project.org/;

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
