{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libuninameslist";
  version = "20230916";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = pname;
    rev = version;
    sha256 = "sha256-8mLXTvi4KbU4NiCPaJINTeFbnTAabGDg8ufpSHSqy0Y=";
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
