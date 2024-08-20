{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "dtkcommon";
  version = "5.6.32";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-e+8kG9bB6iby2RgD8jn75GyefLRHNnjD+n04hXbi5ec=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Public project for building DTK Library";
    homepage = "https://github.com/linuxdeepin/dtkcommon";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
