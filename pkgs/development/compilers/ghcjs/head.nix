{ fetchgit, fetchFromGitHub, bootPkgs }:

bootPkgs.callPackage ./base.nix {
  version = "0.2.020170323";

  inherit bootPkgs;

  ghcjsSrc = fetchFromGitHub {
    # TODO: switch back to the regular ghcjs repo
    # when https://github.com/ghcjs/ghcjs/pull/573 is merged.
    owner = "basvandijk";
    repo = "ghcjs";
    rev = "f743ca7bfee006412376f42c247af1e0a98de95a";
    sha256 = "1ixzrj5bg4ig0a8f6w11774sqp9sqlkdb0jyvmc5q37aq01w7wm5";
  };
  ghcjsBootSrc = fetchgit {
    # TODO: switch back to git://github.com/ghcjs/ghcjs-boot.git
    # when https://github.com/ghcjs/ghcjs-boot/pull/41 is merged.
    url = git://github.com/basvandijk/ghcjs-boot.git;
    rev = "8020b2a9be585e958050c0a2c9144961bc8fad38";
    sha256 = "1n6xmcn6dwp1lsalyr84gqbx41qycisx5dxdxmw4wdh0v2pclqrq";
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
