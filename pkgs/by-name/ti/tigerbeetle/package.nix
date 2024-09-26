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
    "universal-macos" = "sha256-VtKM+Fw1yy0KYvbtxerYykEbYv1hCc81ckfETH36vCU=";
    "x86_64-linux" = "sha256-LtnLLWSOUtnp27swwCrRiA3NIKqrOD2MZylXKbLm2fw=";
    "aarch64-linux" = "sha256-tmlizjB8BWtbQd75RoYvIsRxqEuj1V7Fx9LgArvphm4=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tigerbeetle";
  version = "0.16.2";

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
    updateScript = nix-update-script { };
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
