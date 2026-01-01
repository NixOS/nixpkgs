{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "vault-bin";
<<<<<<< HEAD
  version = "1.21.1";
=======
  version = "1.20.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
        x86_64-linux = "sha256-k+dHuEXjaWDz5TMf0HLdVD0MbvA2Z9+/wSkUp5Yc8rc=";
        aarch64-linux = "sha256-Ss07jlpVXeWyanXqTZK7uxmI6IYcuEfNKkw8t3oqM+o=";
        i686-linux = "sha256-hfYJmYHna4LucvMIn/6lf1R2DabISF9TqBYlIcjkrxc=";
        x86_64-darwin = "sha256-8FwwDMuer0TRobS0+/yECZfWydnt7AYOzpv2gIPLEuI=";
        aarch64-darwin = "sha256-3K3TI2CzDqxxEC5jYFLejMDB08SzxScbqmIjjvU7kYQ=";
=======
        x86_64-linux = "sha256-n687yeuM1+1m2TfgT3AaMBOfE8cqbbG0Gq9Imb9olno=";
        aarch64-linux = "sha256-+MRuCMkskd29xaoAjj42Re1eRra3SKMiciUOG9HwsN4=";
        i686-linux = "sha256-L1zYFc2nam/pFq/groxeWvyK+ujHOHqvUkR96hPC7jU=";
        x86_64-darwin = "sha256-t0j3Wr6IrFfN6FcZ3ZF+9qYjR/K6R8o06ebLJohr54w=";
        aarch64-darwin = "sha256-F/M9ULCkfArlBcLqfR8i1gVcspfe8XEag6etdFXQmqA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Tool for managing secrets, this binary includes the UI";
    homepage = "https://www.vaultproject.io";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Tool for managing secrets, this binary includes the UI";
    homepage = "https://www.vaultproject.io";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsl11;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      offline
      psyanticy
      Chili-Man
      techknowlogick
    ];
<<<<<<< HEAD
    teams = [ lib.teams.serokell ];
=======
    teams = [ teams.serokell ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
