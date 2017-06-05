{ fetchgit, fetchFromGitHub, bootPkgs }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.020170323";

  inherit bootPkgs;

  ghcjsSrc = fetchFromGitHub {
    # TODO: switch back to the regular ghcjs repo
    # when https://github.com/ghcjs/ghcjs/pull/573 is merged.
    owner = "k0001";
    repo = "ghcjs";
    rev = "600015e085a28da601b65a41c513d4a458fcd184";
    sha256 = "01kirrg0fnfwhllvwgfqjiwzwj4yv4lyig87x61n9jp6y5shzjdx";
  };
  ghcjsBootSrc = fetchgit {
    # TODO: switch back to git://github.com/ghcjs/ghcjs-boot.git
    # when https://github.com/ghcjs/ghcjs-boot/pull/41 is merged.
    url = git://github.com/basvandijk/ghcjs-boot.git;
    rev = "19a3b157ecb807c2224daffda5baecc92b76af35";
    sha256 = "16sgr8vfr1nx5ljnk8gckgjk70zpa67ix4dbr9aizkwyz41ilfrb";
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
