{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "vollkorn";
  version = "4.105";

  src = fetchzip {
    url = "http://vollkorn-typeface.com/download/vollkorn-${
      builtins.replaceStrings [ "." ] [ "-" ] version
    }.zip";
    stripRoot = false;
    hash = "sha256-oG79GgCwCavbMFAPakza08IPmt13Gwujrkc/NKTai7g=";
  };

  outputs = [
    "out"
    "webfont"
  ];

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "http://vollkorn-typeface.com/";
    description = "Free and healthy typeface for bread and butter use";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.schmittlauch ];
  };
}
