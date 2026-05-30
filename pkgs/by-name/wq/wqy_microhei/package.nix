{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wqy-microhei";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/wqy-microhei-${finalAttrs.version}-beta.tar.gz";
    hash = "sha256-KAKsgCOqNqZupudEWFTjoHjTd///QhaTQb0jeHH3IT4=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Chinese Unicode font optimized for screen display";
    homepage = "http://wenq.org";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pkmx ];
    platforms = lib.platforms.all;
  };
})
