{
  lib,
  stdenv,
  rustPlatform,
  writeText,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "metadata_god-rs";
    inherit version src;

    # failed to select a version
    cargoLock.lockFile = ./Cargo.lock;

    postUnpack = ''
      echo 'resolver = "2"' >> ${src.name}/Cargo.toml
      substituteInPlace ${src.name}/rust/Cargo.toml \
        --replace-fail "1.0.89" "*" \
        --replace-fail "=2.5.0" "*" \
        --replace-fail "0.21.0" "*"
      cp ${./Cargo.lock} ${src.name}/Cargo.lock
    '';

    passthru.libraryPath = "lib/libmetadata_god.so";
  };

  fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
    function(apply_cargokit target manifest_dir lib_name any_symbol_name)
      set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
    endfunction()
  '';
in
stdenv.mkDerivation {
  pname = "metadata_god";
  inherit version src;
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall

    cp ${fakeCargokitCmake} cargokit/cmake/cargokit.cmake
    cp -r . $out

    runHook postInstall
  '';
}
