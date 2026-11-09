{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "2.2.1";

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
        x86_64-linux = "sha256-vICxPLlpwTeI2JuaYuOLCqJRZzAXiK5l5hPZp6leZd4=";
        aarch64-linux = "sha256-v/+0NnBqog38znsky6zri/IzFa3rn2VKL/2e88xPZeY=";
        i686-linux = "sha256-p+9yhTij4dvyjMht3675ayqh1P0Opx1jK3u3pAWGl2I=";
        aarch64-darwin = "sha256-BVyfRgkvdNMmpqQC9Kxys4ld90fqlRTpi1rRunmMKYc=";
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
