{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "dtkcommon";
  version = "5.6.29";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-1u+GhPI5F3t2h14VlRKpyPNArGoGgWOk2zA8D6vR6nU=";
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
