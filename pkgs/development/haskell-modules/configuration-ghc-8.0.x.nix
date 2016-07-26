{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_35;

  # Disable GHC 8.0.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # cabal-install can use the native Cabal library.
  cabal-install = super.cabal-install.override { Cabal = null; };

  # jailbreak-cabal can use the native Cabal library.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  ghcjs-prim = self.callPackage ({ mkDerivation, fetchgit, primitive }: mkDerivation {
    pname = "ghcjs-prim";
    version = "0.1.0.0";
    src = fetchgit {
      url = git://github.com/ghcjs/ghcjs-prim.git;
      rev = "dfeaab2aafdfefe46bf12960d069f28d2e5f1454"; # ghc-7.10 branch
      sha256 = "19kyb26nv1hdpp0kc2gaxkq5drw5ib4za0641py5i4bbf1g58yvy";
    };
    buildDepends = [ primitive ];
    license = pkgs.stdenv.lib.licenses.bsd3;
    broken = true;   # needs template-haskell >=2.9 && <2.11
  }) {};

  # ghc-mod has a ghc-8 branch that has not yet been merged
  ghc-mod = super."ghc-mod".overrideDerivation (attrs: rec {
    src = pkgs.fetchFromGitHub {
      owner  = "DanielG";
      repo   = "ghc-mod";
      rev    = "f2c7b01e372dd8c516b1ccbe5a1025cc7814347c";
      sha256 = "1i45196qrzlhgbisnvkzni4n54saky0i1kyla162xcb5cg3kf2ji";
    };
  });

  # https://github.com/ygale/timezone-series/issues/2
  timezone-series = appendPatch super.timezone-series (pkgs.fetchpatch {
    url = "https://github.com/ryantrinkle/timezone-series/commit/f8dece8c016db6476e2bb0d4f972769a76f6ff40.patch";
    sha256 = "01wxhknsnn7lyl9v8viz7m5zhmyi3bqpbva7d3dx1dxn0nmkfh6a";
  });

}
