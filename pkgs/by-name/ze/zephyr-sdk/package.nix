{ lib
, stdenv
, fetchurl
, python3
, autoPatchelfHook
, callPackage
}:

let
  srcjson = builtins.fromJSON (builtins.readFile ./src.json);
in stdenv.mkDerivation (finalAttrs: {
  pname = "zephyr-sdk";
  inherit (srcjson) version;

  src = fetchurl (srcjson.tar.${stdenv.hostPlatform.system});

  nativeBuildInputs = [
    stdenv.cc.cc
    python3
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  passthru.updateScript = callPackage ./update.nix { };

  meta = with lib; {
    homepage = "https://github.com/zephyrproject-rtos/sdk-ng";
    description = "Collection of compilers and tools for the Zephyr RTOS";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    # dont build on hydra, big binary distribution
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ mib ];
    sourceProvenance = with sourceTypes; [
      binaryFirmware
      binaryNativeCode
    ];
  };
})
