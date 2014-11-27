{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, iconnamingutils, gtk, gdk_pixbuf, librsvg, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${gnome3.version}/${name}.tar.xz";
    sha256 = "b776a7ad58c97f4c1ede316e44d8d054105429cb4e3a8ec46616a14b11df48ee";
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor_icon_theme ];

  buildInputs = [ gdk_pixbuf librsvg ];
  
  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
