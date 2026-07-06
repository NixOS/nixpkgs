{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
  version = "2.0.3";

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
        x86_64-linux = "sha256-THVYezhV7TmChy8IKsE8Agx6ks4wFctuk+GevXhwRv8=";
        aarch64-linux = "sha256-Wmlpw9gzbdCvgCwf3Nh9JPjjmDKS2P0TNYaRvKqO4fg=";
        i686-linux = "sha256-Fdxq1r1G17kiCl7b9OBrWwkyo+VoKOvrUPf0p4wZlcs=";
        x86_64-darwin = "sha256-tyQzmycXo4kSvo1X4afFU2aWuXyvyvw0mb81eiH3WjE=";
        aarch64-darwin = "sha256-+zor3j+7saG6AnuIlkJSAsCkMHYuhm0Abmt6TTu8bZI=";
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
      "x86_64-darwin"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
}
