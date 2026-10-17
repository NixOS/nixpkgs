{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "twemoji-colr";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/mozilla/twemoji-colr/releases/download/v${finalAttrs.version}/Twemoji.Mozilla.ttf";
    hash = "sha256-bZAVLuDSnoL+Kod5OvWqS3rRPmU4NgiJ4UHoHtKZ7o4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/Twemoji.Mozilla.ttf
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Twemoji font in COLR/CPAL layered format";
    homepage = "https://github.com/mozilla/twemoji-colr";
    license = with lib.licenses; [
      asl20
      cc-by-40
    ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
