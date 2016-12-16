{ fetchgit, fetchFromGitHub, bootPkgs }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.020161101";

  # deprecated on HEAD, directly included in the distribution
  ghcjs-prim = null;
  inherit bootPkgs;

  ghcjsSrc = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "899c834a36692bbbde9b9d16fe5b92ce55a623c4";
    sha256 = "024yj4k0dxy7nvyq19n3xbhh4b4csdrgj19a3l4bmm1zn84gmpl6";
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
