{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "2.2.2";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        i686-linux = "linux_386";
        aarch64-darwin = "darwin_arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-uV7scV/uXZTa1e2R2XTManncl2iHXeRoic0eL1KkCF4=";
        aarch64-linux = "sha256-zDVVc88PuqG2KatYb8gaqqn88q0fUiq1ml0oYhPZMR8=";
        i686-linux = "sha256-Ul3SxXYCWe69+v+GKoK6Cj2A9LikfWL9dwfmpe8aFyw=";
        aarch64-darwin = "sha256-9bk5pP8trtQXBDEPS3Xcm9KNH+/QXYRh/KuhniJyaQk=";
      };
    in
    fetchzip {
      url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_${suffix}.zip";
      stripRoot = false;
      inherit hash;
    };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    install -D vault $out/bin/vault
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/vault --help
    $out/bin/vault version
    runHook postInstallCheck
  '';

  dontPatchELF = true;
  dontPatchShebangs = true;

  passthru.updateScript = ./update-bin.sh;

  meta = {
    description = "Tool for managing secrets, this binary includes the UI";
    homepage = "https://www.vaultproject.io";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      psyanticy
      Chili-Man
      techknowlogick
    ];
    mainProgram = "vault";
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
