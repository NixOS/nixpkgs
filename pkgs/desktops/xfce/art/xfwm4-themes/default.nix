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
    url = "mirror://xfce/src/art/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-MhTV8A6XA7XoyefDKH1gbe3scoXOtNXbMy6TraZv1XU=";
  };

  passthru.updateScript = httpTwoLevelsUpdater {
    url = "https://archive.xfce.org/src/art/${pname}";
  };

  meta = with lib; {
    homepage = "https://www.xfce.org/";
    description = "Themes for Xfce";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
