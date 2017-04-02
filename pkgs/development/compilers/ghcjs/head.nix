{ fetchgit, fetchFromGitHub, bootPkgs }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.020170323";

  # deprecated on HEAD, directly included in the distribution
  ghcjs-prim = null;
  inherit bootPkgs;

  ghcjsSrc = fetchFromGitHub {
    # TODO: switch back to the regular ghcjs repo
    # when https://github.com/ghcjs/ghcjs/pull/573 is merged.
    owner = "basvandijk";
    repo = "ghcjs";
    rev = "e6cdc71964a1c2e4184416a493e9d384c408914c";
    sha256 = "00fk9qwyx4vpvr0h9jbqxwlrvl6w63l5sq8r357prsp6xyv5zniz";
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
