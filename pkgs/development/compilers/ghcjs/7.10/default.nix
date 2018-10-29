{ fetchgit, fetchFromGitHub, bootPkgs, cabal-install }:

bootPkgs.callPackage ../base.nix {
  version = "0.2.0";

  inherit bootPkgs cabal-install;

  ghcjsSrc = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "689c7753f50353dd05606ed79c51cd5a94d3922a";
    sha256 = "076020a9gjv8ldj5ckm43sbzq9s6c5xj6lpd8v28ybpiama3m6b4";
  };
  ghcjsBootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "8c549931da27ba9e607f77195208ec156c840c8a";
    sha256 = "0yg9bnabja39qysh9pg1335qbvbc0r2mdw6cky94p7kavacndfdv";
    fetchSubmodules = true;
  };

  shims = import ./shims.nix { inherit fetchFromGitHub; };
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
  stage2 = import ./stage2.nix;

  patches = [ ./boot.patch ];
}
