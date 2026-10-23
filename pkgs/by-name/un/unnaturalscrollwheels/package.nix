{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  _7zz,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unnaturalscrollwheels";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/ther0n/UnnaturalScrollWheels/releases/download/${finalAttrs.version}/UnnaturalScrollWheels-${finalAttrs.version}.dmg";
    hash = "sha256-t1w+XrsT+UBT5ZPTP04QGTJ9fLYDQiFL6uZaq3hD64g=";
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
