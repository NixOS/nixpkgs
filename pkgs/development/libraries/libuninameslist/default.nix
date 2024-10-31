{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20240910";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "libuninameslist";
    rev = version;
    hash = "sha256-Pi30c3To57AzY59i39JVG2IUkGnq7CEAQkqJ1f5AZhw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    homepage = "https://github.com/fontforge/libuninameslist/";
    changelog = "https://github.com/fontforge/libuninameslist/blob/${version}/ChangeLog";
    description = "Library of Unicode names and annotation data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
    platforms = platforms.all;
  };
}
