{
  lib,
  stdenv,
  fetchzip,
  buildFHSEnv,
}:
let
  src = fetchzip {
    url = "https://github.com/CordyJ/Open-TuringPlus/releases/download/v6.2.1/opentplus-62-linux64.tar.gz";
    sha256 = "sha256-FoOlOcRWpStg4aerjr+FmcXXnwYftrqG1j4iZJ+4AzE=";
  };

  tpc = buildFHSEnv {
    name = "turingplus-tpc-bootstrap";
    executableName = "tpc";

    targetPkgs =
      pkgs: with pkgs; [
        bash
        gcc
      ];

    extraBuildCommands = ''
      mkdir -p $out/usr/local/{lib,include}/tplus
      cp ${src}/lib/* $out/usr/local/lib/tplus/
      cp -r ${src}/include/* $out/usr/local/include/tplus/
    '';

    runScript = ''env NIX_CFLAGS_COMPILE=-std=gnu89 ${src}/bin/tpc'';
  };

  tssl = buildFHSEnv {
    name = "turingplus-tssl-bootstrap";
    executableName = "tssl";

    targetPkgs =
      pkgs: with pkgs; [
        bash
        gcc
      ];

    extraBuildCommands = ''
      mkdir -p $out/usr/local/{lib,include}/tplus
      cp ${src}/lib/* $out/usr/local/lib/tplus/
      cp -r ${src}/include/* $out/usr/local/include/tplus/
    '';

    runScript = ''${src}/bin/tssl'';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "turingplus-bootstrap";
  version = "6.2.1";

  inherit src;

  buildInputs = [
    tpc
    tssl
  ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,include}
    cp ${tpc}/bin/tpc $out/bin/
    cp ${tssl}/bin/tssl $out/bin/
    cp ${src}/lib/* $out/lib/
    cp -r ${src}/include/* $out/include/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Extended version of the Turing programming language with concurrency and systems programming features";
    mainProgram = "tpc";
    platforms = [ "x86_64-linux" ];
    homepage = "https://github.com/CordyJ/Open-TuringPlus";
    downloadPage = "https://github.com/CordyJ/Open-TuringPlus/releases";
    changelog = "https://github.com/CordyJ/Open-TuringPlus/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ MysteryBlokHed ];
  };
})
