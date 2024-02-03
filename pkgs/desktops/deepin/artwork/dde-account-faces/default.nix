{ stdenvNoCC
, lib
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "dde-account-faces";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-/eTGy+9fcYmGrh09RdCIZ2Cn12gTaGtg4Tluv25n5r0=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}/var" ];

  meta = with lib; {
    description = "Account faces of deepin desktop environment";
    homepage = "https://github.com/linuxdeepin/dde-account-faces";
    license = with licenses; [ gpl3Plus cc0 ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
