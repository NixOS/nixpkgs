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
      x86_64-linux = "sha256-wCrMB2rUr4HGAAGxYeygnBR5cCpoxUbuVVYPR7p004I=";
      aarch64-linux = "sha256-CUjuYspPQQw4L3SZSkgEAUoySBxB1X/AQHns9j4zfr0=";
      armv7l-linux = "sha256-83Rul8eikB2+AcgVQK8M/vVGj5eAR4dPNqx8lHAcgBQ=";
      x86_64-darwin = "sha256-fwfemZe1KTtRgdTPuCR+FBah5SrQnzevgsuZsoe8U0U=";
      aarch64-darwin = "sha256-492zgY6rdipxeoXiK5BXTbXeD0x2DtrGxEt4lqr9ZLE=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "1.1.10";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  updateScript = ./update.sh;

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
