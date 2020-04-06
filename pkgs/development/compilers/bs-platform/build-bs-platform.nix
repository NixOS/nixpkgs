# This file is based on https://github.com/turboMaCk/bs-platform.nix/blob/master/build-bs-platform.nix
# to make potential future updates simpler

{ stdenv, fetchFromGitHub, ninja, runCommand, nodejs, python3,
  ocaml-version, version, src,
  ocaml ? (import ./ocaml.nix {
    version = ocaml-version;
    inherit stdenv;
    src = "${src}/ocaml";
  }),
  custom-ninja ? (ninja.overrideAttrs (attrs: {
    src = runCommand "ninja-patched-source" {} ''
      mkdir -p $out
      tar zxvf ${src}/vendor/ninja.tar.gz -C $out
    '';
    patches = [];
  }))
}:

let
  bin_folder = if stdenv.isDarwin then "darwin" else "linux";
in

stdenv.mkDerivation rec {
  inherit src version;
  pname = "bs-platform";

  BS_RELEASE_BUILD = "true";

  # BuckleScript's idiosyncratic build process only builds artifacts required
  # for editor-tooling to work when this environment variable is set:
  # https://github.com/BuckleScript/bucklescript/blob/7.2.0/scripts/install.js#L225-L227
  BS_TRAVIS_CI = "1";

  buildInputs = [ nodejs python3 custom-ninja ];

  patchPhase = ''
    sed -i 's:./configure.py --bootstrap:python3 ./configure.py --bootstrap:' ./scripts/install.js
    mkdir -p ./native/${ocaml-version}/bin
    ln -sf ${ocaml}/bin/*  ./native/${ocaml-version}/bin
  '';

  # avoid building the development version, will break aarch64 build
  dontConfigure = true;

  buildPhase = ''
    # This is an unfortunate name, but it's actually how to build a release
    # binary for BuckleScript
    node scripts/install.js
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rf jscomp lib ${bin_folder} vendor odoc_gen native bsb bsc bsrefmt $out
    mkdir $out/lib/ocaml
    cp jscomp/runtime/js.* jscomp/runtime/*.cm* $out/lib/ocaml
    cp jscomp/others/*.ml jscomp/others/*.mli jscomp/others/*.cm* $out/lib/ocaml
    cp jscomp/stdlib-406/*.ml jscomp/stdlib-406/*.mli jscomp/stdlib-406/*.cm* $out/lib/ocaml
    cp bsconfig.json package.json $out
    ln -s $out/bsb $out/bin/bsb
    ln -s $out/bsc $out/bin/bsc
    ln -s $out/bsrefmt $out/bin/bsrefmt
  '';
}
