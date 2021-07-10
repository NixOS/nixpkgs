{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20210626";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256-tp5yLgIvnDgxkVEsyXQttrfBYYX3aJS0DQK9Db9xhPQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://github.com/fontforge/libuninameslist/";
    description = "A Library of Unicode names and annotation data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
    platforms = platforms.all;
  };
}
