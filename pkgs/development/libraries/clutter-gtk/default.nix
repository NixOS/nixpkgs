{ fetchurl, stdenv, pkgconfig, clutter, gtk }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-0.10.4";

  src = fetchurl {
    url = "http://source.clutter-project.org/sources/clutter-gtk/0.10/${name}.tar.bz2";
    sha256 = "04mrq5ddj24zhh7dvyp9bl8510wq7qpmy3rl3wiqwl9c43gahd01";
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
