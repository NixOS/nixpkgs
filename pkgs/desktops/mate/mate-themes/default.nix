{ stdenv, fetchurl, pkgconfig, intltool, mate, gnome3, gtk2, gtk_engines,
  gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "mate-themes-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = gnome3.version;
  minor-ver = {
    "3.18" = "4";
    "3.20" = "12";
    "3.22" = "3";
  }."${major-ver}";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/themes/${major-ver}/${name}.tar.xz";
    sha256 = {
      "3.18" = "1h3z705jrg7gng5glf51ksszjz6v81qq83qvmfpv1v69bwn6fy4b";
      "3.20" = "15s2xp2cq9x8iikvbywr5gl8l33i57i1xvbv4jc2qipnkn3c4yca";
      "3.22" = "0p1rf5q2nr1vsab3pljwycclbrnwylvp88d0dhk8as0d6n6fp85k";
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
