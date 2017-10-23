{ fetchgit, fetchFromGitHub, bootPkgs }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.020170323";

  inherit bootPkgs;

  ghcjsSrc = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs";
    rev = "2b3759942fb5b2fc1a58d314d9b098d4622fa6b6";
    sha256 = "15asapg0va8dvcdycsx8dgk4xcpdnhml4h31wka6vvxf5anzz8aw";
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
