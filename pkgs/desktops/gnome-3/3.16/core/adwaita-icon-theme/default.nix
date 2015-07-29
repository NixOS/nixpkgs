{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, iconnamingutils, gtk, gdk_pixbuf, librsvg, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${gnome3.version}/${name}.tar.xz";
    sha256 = "a3c8ad3b099ca571b423811a20ee9a7a43498cfa04d299719ee43cd7af6f6eb1";
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor_icon_theme ];

  buildInputs = [ gdk_pixbuf librsvg ];

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];

  # remove a tree of dirs with no files within
  postInstall = '' rm -r "$out/locale" '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
