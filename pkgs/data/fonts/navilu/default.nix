{ lib, mkFont, fetchFromGitHub, fontforge }:

mkFont rec {
  pname = "navilu-font";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "aravindavk";
    repo = "Navilu";
    rev = "v${version}";
    sha256 = "1vm6n04siaa0zf6jzp5s2gzgr2qxs3vdnmcmg4dcy07py2kd2fla";
  };

  dontBuild = false;
  nativeBuildInputs = [ fontforge ];
  preBuild = "patchShebangs generate.pe";

  meta = with lib; src.meta // {
    description = "A Kannada handwriting font";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
