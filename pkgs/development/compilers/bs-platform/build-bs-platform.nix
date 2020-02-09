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
stdenv.mkDerivation {
  inherit src version;
  pname = "bs-platform";
  BS_RELEASE_BUILD = "true";
  buildInputs = [ nodejs python3 custom-ninja ];

  patchPhase = ''
    sed -i 's:./configure.py --bootstrap:python3 ./configure.py --bootstrap:' ./scripts/install.js
    mkdir -p ./native/${ocaml-version}/bin
    ln -sf ${ocaml}/bin/*  ./native/${ocaml-version}/bin
    rm -f vendor/ninja/snapshot/ninja.linux
    cp ${custom-ninja}/bin/ninja vendor/ninja/snapshot/ninja.linux
  '';

  configurePhase = ''
    node scripts/ninja.js config
  '';

  buildPhase = ''
    # This is an unfortunate name, but it's actually how to build a release
    # binary for BuckleScript
    node scripts/install.js
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rf jscomp lib vendor odoc_gen native $out
    cp bsconfig.json package.json $out
    ln -s $out/lib/bsb $out/bin/bsb
    ln -s $out/lib/bsc $out/bin/bsc
    ln -s $out/lib/bsrefmt $out/bin/bsrefmt
  '';
}
