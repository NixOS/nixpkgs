{
  lib,
  stdenvNoCC,
  fetchzip,
  testers,
  tigerbeetle,
  nix-update-script,
}:
let
  platform =
    if stdenvNoCC.hostPlatform.isDarwin then "universal-macos" else stdenvNoCC.hostPlatform.system;
  hash = builtins.getAttr platform {
    "universal-macos" = "sha256-1U24bdd4tvkzZmsRrrc4AUwxm9IhxHNAcPtxxX5ZO2w=";
    "x86_64-linux" = "sha256-DCEqAePHkNj0bfgW5l83DyZG5+bre6C6C7AMbhxwytQ=";
    "aarch64-linux" = "sha256-jKpt7hqCbgcBv9npR7IhryaCgrdOlX40Icq9T10/Af0=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tigerbeetle";
  version = "0.16.42";

  src = fetchzip {
    url = "https://github.com/tigerbeetle/tigerbeetle/releases/download/${finalAttrs.version}/tigerbeetle-${platform}.zip";
    inherit hash;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src/tigerbeetle $out/bin/tigerbeetle

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = tigerbeetle;
      command = "tigerbeetle version";
    };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://tigerbeetle.com/";
    description = "Financial accounting database designed to be distributed and fast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      danielsidhion
      nwjsmith
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ] ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "tigerbeetle";
  };
})
