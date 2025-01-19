{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
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

  nativeBuildInputs = [ cmake ];

  dontWrapQtApps = true;

  meta = {
    description = "Public project for building DTK Library";
    homepage = "https://github.com/linuxdeepin/dtkcommon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
