{ fetchgit, fetchFromGitHub, bootPkgs, cabal-install }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.120171220";

  inherit bootPkgs cabal-install;

  ghcjsSrc = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "665624644d5d476f9e4e4c89a2717b9d84151e39";
    sha256 = "1ar8x86h7qy7hk1gckv8vbmc2abqyj7ma1mk1ndbyja83bvqaxs4";
  };
  ghcjsBootSrc = fetchgit {
    url = git://github.com/ghcjs/ghcjs-boot.git;
    rev = "106e144cca6529a1b9612c11aea5d6ef65b96745";
    sha256 = "0gxg8iiwvm93x1dwhxypczn9qiz4m1xvj8i7cf4snfdy2jdyhi5l";
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

  patches = [ ./ghcjs-head.patch ];
}
