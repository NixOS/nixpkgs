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

  getLibraryPath = ''
    String _getLibraryPath() {
      if (kIsWeb) {
        return './';
      }
      try {
        return Platform.resolvedExecutable + '/../lib/libvodozemac_bindings_dart.so';
      } catch (_) {
        return './';
      }
    }
  '';
in
stdenv.mkDerivation {
  pname = "flutter_vodozemac";
  inherit version src;
  passthru = src.passthru // {
    # vodozemac-wasm in fluffychat will make use of it
    inherit (rustDep) cargoDeps;
  };

  installPhase = ''
    runHook preInstall

    cp -r "$src" "$out"
    pushd $out
      chmod +rwx cargokit/cmake/cargokit.cmake
      cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
      chmod +rw lib/flutter_vodozemac.dart
      substituteInPlace lib/flutter_vodozemac.dart \
        --replace-warn "libraryPath: './'" "libraryPath: _getLibraryPath()"
      echo "${getLibraryPath}" >> lib/flutter_vodozemac.dart
    popd

    runHook postInstall
  '';
}
