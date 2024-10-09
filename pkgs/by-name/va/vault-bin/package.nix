{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "1.18.0";

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
        x86_64-linux = "sha256-fyVkSZ20tUcBv9/iT1h3o/2KkoCJ5op7DBoMc0US7SM=";
        aarch64-linux = "sha256-Vsc0ra+OzrDBwmKke0ef4kfy5CWu5m34gC7u0BDL7uo=";
        i686-linux = "sha256-3uAkBPOoMbdfS5EfII03JbVl1ekfRXm4yv1rL5A7x7c=";
        x86_64-darwin = "sha256-fydYqDEihbGuZ9I1quJSJk+lJxnSkqF+t1mOP8EA2Ok=";
        aarch64-darwin = "sha256-yJmNM9eQydbRdY6+JK28hhzXJ9Hj3CcwUJkhS60aCyA=";
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
        mkaito
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
