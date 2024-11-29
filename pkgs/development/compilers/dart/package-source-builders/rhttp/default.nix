{
  lib,
  rustPlatform,
  stdenv,
}:

{ version, src, ... }:

let
  rustDep = rustPlatform.buildRustPackage {
    pname = "rhttp-rs";
    inherit version src;

    sourceRoot = "${src.name}/rust";

    cargoHash =
      {
        _0_9_1 = "sha256-Gl3ArdSuw3/yi/JX6oloKJqerSJjTfK8HXRNei/LO+4=";
      }
      .${"_" + (lib.replaceStrings [ "." ] [ "_" ] version)} or (throw ''
        Unsupported version of pub 'rhttp': '${version}'
        Please add cargoHash here. If the cargoHash
        is the same with existing versions, add an alias here.
      '');

    env.RUSTFLAGS = "--cfg reqwest_unstable";

    passthru.libraryPath = "lib/librhttp.so";
  };

in
stdenv.mkDerivation {
  pname = "rhttp";
  inherit version src;
  inherit (src) passthru;

  patches = [ ./cargokit.patch ];

  postPatch = ''
    substituteInPlace ./cargokit/cmake/cargokit.cmake --replace-fail "OUTPUT_LIB" "${rustDep}/${rustDep.passthru.libraryPath}"
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out/
    cp -r ./* $out/

    runHook postInstall
  '';
}
