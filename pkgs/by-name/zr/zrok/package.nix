{
  lib,
  stdenv,
  fetchzip,
  installShellFiles,
  bintools,
  versionCheckHook,
  writeShellScript,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "1.1.10";

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "arm64";
        armv7l-linux = "armv7";
      };
    in
    fetchzip {
      url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_linux_${arch}.tar.gz";
      stripRoot = false;
      hash = selectSystem {
        x86_64-linux = "sha256-wCrMB2rUr4HGAAGxYeygnBR5cCpoxUbuVVYPR7p004I=";
        aarch64-linux = "sha256-CUjuYspPQQw4L3SZSkgEAUoySBxB1X/AQHns9j4zfr0=";
        armv7l-linux = "sha256-83Rul8eikB2+AcgVQK8M/vVGj5eAR4dPNqx8lHAcgBQ=";
      };
    };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    patchelf --set-interpreter ${bintools.dynamicLinker} zrok
    installBin zrok

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "version";

  passthru.updateScript = writeShellScript "update-zrok" ''
    ${lib.getExe nix-update} pkgsCross.gnu64.zrok
    ${lib.getExe nix-update} pkgsCross.aarch64-multiplatform.zrok --version skip
    ${lib.getExe nix-update} pkgsCross.armv7l-hf-multiplatform.zrok --version skip
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
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
