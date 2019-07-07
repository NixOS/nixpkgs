{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, iconnamingutils, gtk3, gdk_pixbuf, librsvg, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "adwaita-icon-theme-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "11ij35na8nisvxx3qh527iz33h6z2q1a7iinqyp7p65v0zjbd3b9";
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor-icon-theme ];

  buildInputs = [ gdk_pixbuf librsvg ];

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk3 ];

  # remove a tree of dirs with no files within
  postInstall = '' rm -rf "$out/locale" '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "adwaita-icon-theme";
      attrPath = "gnome3.adwaita-icon-theme";
    };
  };

  meta = with stdenv.lib; {
    platforms = with platforms; linux ++ darwin;
    maintainers = gnome3.maintainers;
  };
}
