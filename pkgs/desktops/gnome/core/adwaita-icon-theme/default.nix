{ lib, stdenv, fetchurl, pkg-config, intltool, gnome
, iconnamingutils, gtk3, gdk-pixbuf, librsvg, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "adwaita-icon-theme";
  version = "40.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/adwaita-icon-theme/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "C2xDbtatmIeoitofcqAZex63OwINjTRKurTH+nJQ+PY=";
  };

  # For convenience, we can specify adwaita-icon-theme only in packages
  propagatedBuildInputs = [ hicolor-icon-theme ];

  buildInputs = [ gdk-pixbuf librsvg ];

  nativeBuildInputs = [ pkg-config intltool iconnamingutils gtk3 ];

  dontDropIconThemeCache = true;

  # remove a tree of dirs with no files within
  postInstall = '' rm -rf "$out/locale" '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "adwaita-icon-theme";
      attrPath = "gnome.adwaita-icon-theme";
    };
  };

  meta = with lib; {
    platforms = with platforms; linux ++ darwin;
    maintainers = teams.gnome.members;
  };
}
