{ fetchurl, stdenv, pkgconfig, clutter, gtk }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-0.10.8";

  src = fetchurl {
    url = "http://source.clutter-project.org/sources/clutter-gtk/0.10/${name}.tar.bz2";
    sha256 = "0508x1jfnlq0zhgscysvfa7i7ljkzm23d2myikvdjwc8ar8zjrvq";
  };

  propagatedBuildInputs = [ clutter gtk ];
  buildNativeInputs = [ pkgconfig ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";

    homepage = http://www.clutter-project.org/;

    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
