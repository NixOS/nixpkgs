{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
let
  info = lib.importJSON ./info.json;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "the-unarchiver";
  inherit (info) version;

  src = fetchurl { inherit (info) url hash; };

  sourceRoot = ".";
  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv "The Unarchiver.app" $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = ./update/update.mjs;

  meta = {
    description = "Unpacks archive files";
    homepage = "https://theunarchiver.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
