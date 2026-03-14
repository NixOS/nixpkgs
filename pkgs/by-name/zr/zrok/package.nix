{
  lib,
  stdenv,
  fetchzip,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux_amd64";
      aarch64-linux = "linux_arm64";
      armv7l-linux = "linux_armv7";
      x86_64-darwin = "darwin_amd64";
      aarch64-darwin = "darwin_arm64";
    }
    .${system} or throwSystem;

  hash =
    {
      x86_64-linux = "sha256-6GlSDelNeR85gZ/AwgwXsK4A+kwUDIJneWsZs2r7Itg=";
      aarch64-linux = "sha256-oAaaqPfA2RjyjJXZqaWngWrcZSAkTowvv0L9xreBGLg=";
      armv7l-linux = "sha256-NKhXFR3R0SsEG2r2MwQWntfF+4BrWNUfk/grAcdv+ug=";
      x86_64-darwin = "sha256-DzVkFrzjtwAyKCfRTJzR9DRdzWQLinTjAhnQrdxJ/4w=";
      aarch64-darwin = "sha256-sMYMOb2iX/RlJMl01P5jwyVKWjhhRph2aWIf0Atgobc=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "1.1.11";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  passthru.updateScript = ./update.sh;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp zrok $out/bin/
    chmod +x $out/bin/zrok
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --set-interpreter "$(< "$NIX_CC/nix-support/dynamic-linker")" "$out/bin/zrok"
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Geo-scale, next-generation sharing platform built on top of OpenZiti";
    homepage = "https://zrok.io";
    license = lib.licenses.asl20;
    mainProgram = "zrok";
    maintainers = [ lib.maintainers.bandresen ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
