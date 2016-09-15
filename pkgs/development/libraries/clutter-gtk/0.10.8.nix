{ fetchurl, stdenv, pkgconfig, clutter, gtk2 }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-0.10.8";

  src = fetchurl {
    urls = [
      "http://download.gnome.org/sources/clutter-gtk/0.10/${name}.tar.bz2"
      "http://source.clutter-project.org/sources/clutter-gtk/0.10/${name}.tar.bz2"
      ];
    sha256 = "0508x1jfnlq0zhgscysvfa7i7ljkzm23d2myikvdjwc8ar8zjrvq";
  };

  propagatedBuildInputs = [ clutter gtk2 ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--disable-introspection" ]; # not needed anywhere AFAIK

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";

    homepage = http://www.clutter-project.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
