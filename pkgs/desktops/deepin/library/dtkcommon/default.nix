{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "dtkcommon";
  version = "5.7.13";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-yQKkqHL5W2mHPE3zchAwtWUH55zrCEJwcVWCheC0rW4=";
  };

  nativeBuildInputs = [ cmake ];

  dontWrapQtApps = true;

  meta = {
    description = "Public project for building DTK Library";
    homepage = "https://github.com/linuxdeepin/dtkcommon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.deepin ];
  };
}
