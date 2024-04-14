{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "dtkcommon";
  version = "5.6.21";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-wRTzgvtmbGJJaIwi1f5m98K2o6g7yZdnKYR1nsDDwk8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "A public project for building DTK Library";
    homepage = "https://github.com/linuxdeepin/dtkcommon";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
