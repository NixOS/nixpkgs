{
  lib,
  stdenv,
  rustPlatform,
  writeText,
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
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall

    cp -r . $out
    cp --no-preserve=mode ${fakeCargokitCmake} $out/cargokit/cmake/cargokit.cmake
    substituteInPlace $out/lib/flutter_vodozemac.dart \
      --replace-fail "libraryPath: './'" "libraryPath: Platform.resolvedExecutable + '/../${rustDep.passthru.libraryPath}'"

    runHook postInstall
  '';
}
