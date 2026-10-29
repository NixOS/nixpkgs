{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vollkorn";
  version = "4.105";

  outputs = [
    "out"
    "webfont"
    "doc"
  ];

  src = fetchzip {
    url = "http://vollkorn-typeface.com/download/vollkorn-${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }.zip";
    stripRoot = false;
    hash = "sha256-oG79GgCwCavbMFAPakza08IPmt13Gwujrkc/NKTai7g=";
  };

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    install -Dm444 {Fontlog,OFL-FAQ,OFL}.txt -t $doc/share/doc/${finalAttrs.pname}-${finalAttrs.version}/
  '';

  meta = {
    homepage = "http://vollkorn-typeface.com/";
    description = "Free and healthy typeface for bread and butter use";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.schmittlauch ];
  };
})
