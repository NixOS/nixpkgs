{
  lib,
  rustPlatform,
  stdenv,
  writeText,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "code_forge-rs";
    inherit version src;

    sourceRoot = "${src.name}/rust";

    cargoHash =
      {
        _10_11_0 = "sha256-T/8JLe4SDZslp/bNKbTwGpAEbN54u9AxBSxj965iTqU=";
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'code_forge': '${version}'
        Please add cargoHash here. If the cargoHash
        is the same with existing versions, add an alias here.
      '');

    # The crate only ships a cdylib and a staticlib, so there is nothing to test.
    doCheck = false;

    passthru.libraryPath = "lib/libcode_forge.so";
  };

  fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
    function(apply_cargokit target manifest_dir lib_name any_symbol_name)
      set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
    endfunction()
  '';
in
stdenv.mkDerivation {
  pname = "code_forge";
  inherit version src;
  inherit (src) passthru;

  # Cargokit cannot run inside the Nix sandbox, so point the plugin at the
  # prebuilt Rust library instead.
  postPatch = ''
    cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
  '';

  installPhase = ''
    runHook preInstall

    cp -r . "$out"

    runHook postInstall
  '';
}
