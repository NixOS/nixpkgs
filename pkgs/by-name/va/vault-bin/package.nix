{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.19.1";

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
        x86_64-linux = "sha256-sKFUVnKG6NIsAI4seRaRQt/qh4MkjL0JSbjWBdeKpow=";
        aarch64-linux = "sha256-k2142jQBtQPz79hr/GDae33j2bMbCi35BS2Qb4PpWKE=";
        i686-linux = "sha256-edSKcSwb9rumMs7oTCOqEpGlmo07u7Nkzl4i5fB+/Hk=";
        x86_64-darwin = "sha256-O1wEfn0EhLTUOXCpWaIIxCQku0Og+0i0SodMrnovPMc=";
        aarch64-darwin = "sha256-3UBvZW+4rYR+ELQkwnV1Z/J409NTE+7rEZkP6ld1y7M=";
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
