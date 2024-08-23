{
  lib,
  rustPlatform,
  pkg-config,
  at-spi2-atk,
  gdk-pixbuf,
  cairo,
  gtk3,
  writeText,
  stdenv,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "super_native_extensions-rs";
    inherit version src;

    sourceRoot = "${src.name}/rust";

    cargoLock =
      rec {
        _0_8_22 = {
          lockFile = ./Cargo-0.8.22.lock;
          outputHashes = {
            "mime_guess-2.0.4" = "sha256-KSw0YUTGqNEWY9pMvQplUGajJgoP2BRwVX6qZPpB2rI=";
          };
        };
        _0_8_21 = _0_8_22;
        _0_8_20 = _0_8_22;
        _0_8_19 = _0_8_22;
        _0_8_18 = _0_8_22;
        _0_8_17 = _0_8_22;
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'super_native_extensions': '${version}'
        Please add ${src}/rust/Cargo.lock
        to this path, and add corresponding entry here. If the lock
        is the same with existing versions, add an alias here.
      '');

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      at-spi2-atk
      gdk-pixbuf
      cairo
      gtk3
    ];

    passthru.libraryPath = "lib/libsuper_native_extensions.so";
  };

  fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
    function(apply_cargokit target manifest_dir lib_name any_symbol_name)
      target_link_libraries("''${target}" PRIVATE ${rustDep}/${rustDep.passthru.libraryPath})
      set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
    endfunction()
  '';

in
stdenv.mkDerivation {
  pname = "super_native_extensions";
  inherit version src;
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall

    cp -r "$src" "$out"
    chmod +rwx $out/cargokit/cmake/cargokit.cmake
    cp ${fakeCargokitCmake} $out/cargokit/cmake/cargokit.cmake

    runHook postInstall
  '';
}
