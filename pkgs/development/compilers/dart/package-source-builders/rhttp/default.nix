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

    useFetchCargoVendor = true;
    cargoHash =
      {
        _0_9_1 = "sha256-ZVl1nesepZnmOWeJPOgE6IDCokQm5FedbA5MBvr5S8c=";
        _0_9_6 = "sha256-vvzb+jNN5lmRrKJ3zqvORvdduqEHRmbp85L/9Zegh/E=";
        _0_9_8 = "sha256-cwb1wYVXOE5YABlMxUDt+OMlDpIlipqeNI7ZFAGHCqo=";
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
