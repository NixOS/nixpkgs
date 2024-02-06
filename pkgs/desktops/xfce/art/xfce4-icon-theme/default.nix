{ lib, stdenv, fetchurl, pkg-config, intltool, gtk3, gnome-icon-theme, tango-icon-theme, hicolor-icon-theme, httpTwoLevelsUpdater }:

stdenv.mkDerivation rec {
  pname  = "xfce4-icon-theme";
  version = "4.4.3";

  src = fetchurl {
    url = "mirror://xfce/src/art/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1HhmktVrilY/ZqXyYPHxOt4R6Gx4y8slqfml/EfPZvo=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    gtk3
  ];

  buildInputs = [
    gnome-icon-theme
    tango-icon-theme
    hicolor-icon-theme
    # missing parent icon theme Industrial
  ];

  dontDropIconThemeCache = true;

  passthru.updateScript = httpTwoLevelsUpdater {
    url = "https://archive.xfce.org/src/art/${pname}";
  };

  meta = with lib; {
    homepage = "https://www.xfce.org/";
    description = "Icons for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eelco ] ++ teams.xfce.members;
  };
}
