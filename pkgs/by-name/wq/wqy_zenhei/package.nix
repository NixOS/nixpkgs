{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wqy-zenhei";
  version = "0.9.45";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/wqy-zenhei-${finalAttrs.version}.tar.gz";
    hash = "sha256-5LfjBkdb+UJ9F1dXjw5FKJMMhMROqj8WfUxC8RDuddY=";
  };

  nativeBuildInputs = [ installFonts ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  meta = {
    description = "Chinese Unicode font with full CJK coverage";
    homepage = "http://wenq.org";
    license = lib.licenses.gpl2; # with font embedding exceptions
    maintainers = [ lib.maintainers.pkmx ];
    platforms = lib.platforms.all;
  };
})
