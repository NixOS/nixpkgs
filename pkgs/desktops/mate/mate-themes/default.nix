{ stdenv, fetchurl, pkgconfig, intltool, mate, gnome3, gtk2, gtk_engines,
  gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "mate-themes-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = gnome3.version;
  minor-ver = {
    "3.18" = "3";
    "3.20" = "10";
  }."${major-ver}";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/themes/${major-ver}/${name}.tar.xz";
    sha256 = {
      "3.18" = "09vglvjnjnm95wxw5b7pn6rf5xrr3nfyqs5c3y1c72z4p3w8qqn5";
      "3.20" = "0bhhidip8qbsq69a9n0dmxfryhvzngiy59vnms6xhya9n7y19hci";
    }."${major-ver}";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ mate.mate-icon-theme gtk2 gtk_engines gtk-engine-murrine
    gdk_pixbuf librsvg ];

  meta = {
    description = "A set of themes from MATE";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
