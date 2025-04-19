{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.19.2";

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
        x86_64-linux = "sha256-11c1zmYHjefDX2bRXfFSzwzhOtAO4hbrbL9bTeAkvDM=";
        aarch64-linux = "sha256-Y5KKw6IMNM9Zix98mRy4HNKBchGrQ3hLhWIlVZwNsK4=";
        i686-linux = "sha256-iFldcD9Tr2oV//PhT3uvG9+xck5c5GWstbVobkyck8U=";
        x86_64-darwin = "sha256-Z678lFCTXmbX4Dtsbrp9pwwP9Qfok01nHpet9yTbn8c=";
        aarch64-darwin = "sha256-uKQHSekbuluRTrwWItQkAJFydsBolmLzCBQ9gMpDbt8=";
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
    maintainers =
      with maintainers;
      teams.serokell.members
      ++ [
        offline
        psyanticy
        Chili-Man
        techknowlogick
      ];
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
