{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vegur";
  version = "${finalAttrs.majorVersion}.${finalAttrs.minorVersion}";
  majorVersion = "0";
  minorVersion = "701";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/vegur_${finalAttrs.majorVersion}${finalAttrs.minorVersion}.zip";
    hash = "sha256-sGb3mEb3g15ZiVCxEfAanly8zMUopLOOjw8W4qbXLPA=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://dotcolon.net/fonts/vegur/";
    description = "Humanist sans serif font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      djacu
      minijackson
    ];
    license = lib.licenses.cc0;
  };
})
