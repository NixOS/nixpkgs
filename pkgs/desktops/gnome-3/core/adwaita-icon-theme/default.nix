{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, iconnamingutils, gtk3, gdk-pixbuf, librsvg, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "adwaita-icon-theme";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15xgz9wzk07442x3s3052as95g0223z4pp9qlsgcs323yama30v6";
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor-icon-theme ];

  buildInputs = [ gdk-pixbuf librsvg ];

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils gtk3 ];

  dontDropIconThemeCache = true;

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
    maintainers = teams.gnome.members;
  };
}
