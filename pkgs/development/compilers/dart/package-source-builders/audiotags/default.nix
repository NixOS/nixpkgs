{
  stdenv,
  lib,
  rustPlatform,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage rec {
    pname = "audiotags-rs";
    inherit version src;

    postPatch = ''
      cp --no-preserve=mode ${cargoLock.lockFile} Cargo.lock
    '';

    sourceRoot = "${src.name}/rust";

    cargoLock.lockFile =
      rec {
        _1_4_2 = _1_4_1;
        _1_4_1 = ./Cargo-1.4.1.lock;
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'audiotags': '${version}'
        Please add Cargo.lock here. If the Cargo.lock
        is the same with existing versions, add an alias here.
      '');

    doCheck = false; # test failed

    passthru.libraryPath = "lib/libaudiotags.so";
  };
in
stdenv.mkDerivation {
  pname = "audiotags";
  inherit version src;
  inherit (src) passthru;

  postPatch = ''
    sed -i -e '/if(NOT EXISTS/,/endif()/d' -e '/if(NOT EXISTS/,/endif()/d' ./linux/CMakeLists.txt
    sed -i 's|.*libaudiotags.so.*|${rustDep}/${rustDep.passthru.libraryPath}|' ./linux/CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
