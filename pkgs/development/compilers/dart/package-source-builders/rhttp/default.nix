{
  lib,
  rustPlatform,
  stdenv,
  replaceVars,
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
        _0_9_6 = "sha256-a11UxG8nbIng+6uOWq/BZxdtRmRINl/7UOc6ap2mgrk=";
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

  patches = [
    (replaceVars ./cargokit.patch {
      output_lib = "${rustDep}/${rustDep.passthru.libraryPath}";
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';
}
