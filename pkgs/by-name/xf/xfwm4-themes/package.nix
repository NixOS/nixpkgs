{
  lib,
  stdenv,
  fetchurl,
  httpTwoLevelsUpdater,
}:

stdenv.mkDerivation rec {
  pname = "xfwm4-themes";
  version = "4.10.0";

  src = fetchurl {
    url = "mirror://xfce/src/art/xfwm4-themes/${lib.versions.majorMinor version}/xfwm4-themes-${version}.tar.bz2";
    sha256 = "sha256-MhTV8A6XA7XoyefDKH1gbe3scoXOtNXbMy6TraZv1XU=";
  };

  passthru.updateScript = httpTwoLevelsUpdater {
    url = "https://archive.xfce.org/src/art/xfwm4-themes";
  };

  meta = {
    homepage = "https://www.xfce.org/";
    description = "Themes for Xfce";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.xfce ];
  };
}
