{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, iconnamingutils, gtk, gdk_pixbuf, librsvg, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "28ba7392c7761996efd780779167ea6c940eedfb1bf37cfe9bccb7021f54d79d";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "adwaita-icon-theme"; attrPath = "gnome3.adwaita-icon-theme"; };
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor-icon-theme ];

  buildInputs = [ gdk_pixbuf librsvg ];

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk ];

  # remove a tree of dirs with no files within
  postInstall = '' rm -rf "$out/locale" '';

  meta = with stdenv.lib; {
    platforms = with platforms; linux ++ darwin;
    maintainers = gnome3.maintainers;
  };
}
