{
  lib,
  stdenv,
  rustPlatform,
  writeText,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "flutter_discord_rpc-rs";
    inherit version src;

    buildAndTestSubdir = "rust";

    cargoHash =
      {
        _1_0_0 = "sha256-C9WDE9+6V59yNCNVeMUY5lRpMJ+8XWpHpxzdTmz+/Yw=";
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'flutter_discord_rpc': '${version}'
        Please add cargoHash here. If the cargoHash
        is the same with existing versions, add an alias here.
      '');

    passthru.libraryPath = "lib/libflutter_discord_rpc.so";
  };

  fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
    function(apply_cargokit target manifest_dir lib_name any_symbol_name)
      set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
    endfunction()
  '';
in
stdenv.mkDerivation {
  pname = "flutter_discord_rpc";
  inherit version src;
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall

    cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
    cp -r . "$out"

    runHook postInstall
  '';
}
