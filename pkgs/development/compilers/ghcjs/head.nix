{ fetchgit, fetchFromGitHub, bootPkgs }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.020161101";

  # deprecated on HEAD, directly included in the distribution
  ghcjs-prim = null;
  inherit bootPkgs;

  ghcjsSrc = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "2dc14802e78d7d9dfa35395d5dbfc9c708fb83e6";
    sha256 = "0cvmapbrwg0h1pbz648isc2l84z694ylnfm8ncd1g4as28lmj0pz";
  };
  ghcjsBootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "b000a4f4619b850bf3f9a45c9058f7a51e7709c8";
    sha256 = "164v0xf33r6mnympp6s70v8j6g7ccyg7z95gjp43bq150ppvisbq";
    fetchSubmodules = true;
  };

  shims = import ./head_shims.nix { inherit fetchFromGitHub; };
  stage1Packages = [
    "array"
    "base"
    "binary"
    "bytestring"
    "containers"
    "deepseq"
    "directory"
    "filepath"
    "ghc-boot"
    "ghc-boot-th"
    "ghc-prim"
    "ghci"
    "ghcjs-prim"
    "ghcjs-th"
    "integer-gmp"
    "pretty"
    "primitive"
    "process"
    "rts"
    "template-haskell"
    "time"
    "transformers"
    "unix"
  ];
  stage2 = import ./head_stage2.nix;
}
