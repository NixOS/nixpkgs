{
  lib,
  rustPlatform,
  writeText,
  stdenv,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "flutter_vodozemac-rs";
    inherit version src;

    sourceRoot = "${src.name}/rust";

    cargoHash =
      {
        _0_2_2 = "sha256-Iw0AkHVjR1YmPe+C0YYBTDu5FsRk/ZpaRyBilcvqm6M=";
        _0_3_0 = "sha256-eKKrcroV2yl/FV2WmgZWFPO5MPAGz0xCvpr0fgIuGZ4=";
        _0_4_1 = "sha256-eKKrcroV2yl/FV2WmgZWFPO5MPAGz0xCvpr0fgIuGZ4=";
        _0_5_0 = "sha256-eKKrcroV2yl/FV2WmgZWFPO5MPAGz0xCvpr0fgIuGZ4=";
        _0_7_1 = "sha256-KsOyQyz9TqcmkHwuf3iA0NQU+pOOtoBVKv1AxZCjxnw=";
        _0_8_1 = "sha256-F2p3kD0MbBaT3Mc/aKoIYP1tfX/DxHuZSY3Z8EPco0k=";
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'flutter_vodozemac': '${version}'
        Please add cargoHash here. If the cargoHash
        is the same with existing versions, add an alias here.
      '');

    passthru.libraryPath = "lib/libvodozemac_bindings_dart.so";
  };

  fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
    function(apply_cargokit target manifest_dir lib_name any_symbol_name)
      set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
    endfunction()
  '';
in
stdenv.mkDerivation {
  pname = "flutter_vodozemac";
  inherit version src;
  passthru = src.passthru // {
    # vodozemac-wasm in fluffychat will make use of it
    inherit (rustDep) cargoDeps;
  };

  patches =
    [ ]
    ++ (lib.optional (lib.versionOlder version "0.8") ./nixed-lib-path_pre-0.8.patch)
    ++ (lib.optional (lib.versionAtLeast version "0.8") ./nixed-lib-path_post-0.8.patch);

  postPatch = ''
    cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./ "$out"

    runHook postInstall
  '';
}
