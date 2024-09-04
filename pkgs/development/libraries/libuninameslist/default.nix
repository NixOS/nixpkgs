{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20240524";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256-LANwM0fhCsscXAdI/qGOmUWDzAhe3g9w3J68g4szDZQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://github.com/fontforge/libuninameslist/";
    description = "Library of Unicode names and annotation data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
    platforms = platforms.all;
  };
}
