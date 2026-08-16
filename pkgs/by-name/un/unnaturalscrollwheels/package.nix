{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  _7zz,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unnaturalscrollwheels";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/ther0n/UnnaturalScrollWheels/releases/download/${finalAttrs.version}/UnnaturalScrollWheels-${finalAttrs.version}.dmg";
    hash = "sha256-KJQnV/XWM+JpW3O29nyGo64Jte6Gw3I54bXfFSAkUrc=";
  };
  sourceRoot = ".";

  # APFS format is unsupported by undmg
  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Invert scroll direction for physical scroll wheels";
    homepage = "https://github.com/ther0n/UnnaturalScrollWheels";
    changelog = "https://github.com/ther0n/UnnaturalScrollWheels/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      emilytrau
      jesssullivan
    ];
    platforms = lib.platforms.darwin;
  };
})
