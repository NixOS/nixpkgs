{ emscripten
, python3
, nodejs
, gnumake
, coreutils
, pkg-config
, stdenvNoCC
, lib
, writeScript
, makeWrapper
, runtimeShell
, wrapCCWith
, writeText
, makeSetupHook
}:

let
  stdenv = stdenvNoCC;
  targetPrefix = "${wasmArch}-unknown-emscripten-";
  wasmArch = stdenvNoCC.targetPlatform.uname.processor;

  unwrapped = stdenv.mkDerivation {
    pname = "${wasmArch}-emscripten-cc";
    version = emscripten.version;

    preferLocalBuild = true;

    dontBuild = true;
    dontConfigure = true;
    enableParallelBuilding = true;

    nativeBuildInputs = [ makeWrapper emscripten ];

    propagatedBuildInputs = [ python3 ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      args=(
        --add-flags -Wno-limited-postlink-optimizations
        --add-flags -sSINGLE_FILE
      )
      makeWrapper ${emscripten}/bin/emcc $out/bin/${targetPrefix}cc "${"$"}{args[@]}"
      makeWrapper ${emscripten}/bin/em++ $out/bin/${targetPrefix}c++ "${"$"}{args[@]}"

      runHook postInstall
    '';

    passthru = {
      isGNU = false;
      isClang = true;
      isEmscripten = true;
      inherit targetPrefix nodejs emscripten;
    };

    meta = emscripten.meta // (with lib; {
      description = "Lightweight Emscripten wrapper that can be cc-wrapped";
      maintainers = with maintainers; [ atnnn ];
      platforms = lib.subtractLists platforms.emscripten platforms.all;
    });
  };

  setupHook = makeSetupHook
    {
      name = "emscripten-cc-setup-hook";
    }
    (writeText "emscriptenCCSetupHook.sh" ''
      addEmscriptenCCEnv () {
        export LD=false
      }
      addEnvHooks "$hostOffset" addEmscriptenCCEnv
    '');

in
wrapCCWith {
  cc = unwrapped;
  extraTools = [ setupHook ];
}
