{
  lib,
  stdenv,
  fetchurl,
  testers,
  trunk-cli,
  autoPatchelfHook,
}:

let
  manifest = lib.importJSON ./manifest.json;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "trunk-cli";
  version = manifest.version;

  src =
    let
      system = stdenv.hostPlatform.system;
    in
    fetchurl (manifest.assets.${system} or (throw "Unsupported system: ${system}"));

  # Work around the "unpacker appears to have produced no directories"
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isElf [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -D trunk $out/bin/trunk

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = trunk-cli;
    };
    updateScript = ./update.py;
  };

  meta = {
    homepage = "https://trunk.io/";
    description = "Developer experience toolkit used to check, test, merge, and monitor code";
    license = lib.licenses.unfree;
    platforms = builtins.attrNames manifest.assets;
    maintainers = with lib.maintainers; [ aaronjheng ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "trunk";
  };
})
