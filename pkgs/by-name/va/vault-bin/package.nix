{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.20.1";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
      suffix = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        i686-linux = "linux_386";
        x86_64-darwin = "darwin_amd64";
        aarch64-darwin = "darwin_arm64";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-enaT1ACAW2jG5IbmKlJMRTDrGlCiIlT0HzZV6MjLeFw=";
        aarch64-linux = "sha256-D0+uRm6+942R3AkSnD03PRtG32hdbKsyVFKk5bGgqGQ=";
        i686-linux = "sha256-fP9Cmp2h2/8Gwe6hCddwRZ7+9yqzxodqhLWytZQBJOc=";
        x86_64-darwin = "sha256-gEXitrmyxl3Dq9T/o4QnG9+Bwfc0IMUPWEqu/U/4Dpk=";
        aarch64-darwin = "sha256-ps4uIJ6tQPyDQ5hJyDksSRTYDwRqbSeIFOuLStrnos4=";
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

  meta = with lib; {
    description = "Tool for managing secrets, this binary includes the UI";
    homepage = "https://www.vaultproject.io";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsl11;
    maintainers = with maintainers; [
      offline
      psyanticy
      Chili-Man
      techknowlogick
    ];
    teams = [ teams.serokell ];
    mainProgram = "vault";
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
