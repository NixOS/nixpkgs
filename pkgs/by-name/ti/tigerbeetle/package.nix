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
    "universal-macos" = "sha256-ryYQyt+qjNKiT3XQuAwaG65I8KIMrkM2QeL9WvFkyik=";
    "x86_64-linux" = "sha256-VgV+K6DDtoX5CjqGUlSAZYVakAs4GWX6+8Fi9v29HjY=";
    "aarch64-linux" = "sha256-euyfFe9iXnAnePYd1u4ymtWqKGrf7vNuOeS0jFtChCA=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tigerbeetle";
  version = "0.16.35";

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
