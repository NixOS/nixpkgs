{ stdenv, fetchurl, pkgconfig, intltool, mate, gnome3, gtk2, gtk_engines,
  gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "mate-themes-${version}";
  version = "3.22.15";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/themes/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0cmlbj6vlkavdirc5xnsgwmy0m11bj9yrbv1dkq46n1s23rvv6wg";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ mate.mate-icon-theme gtk2 gtk_engines gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = {
    description = "A set of themes from MATE";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
