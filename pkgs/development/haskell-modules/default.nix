{ pkgs, stdenv, ghc, all-cabal-hashes
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
, initialPackages ? import ./hackage-packages.nix
, configurationCommon ? import ./configuration-common.nix
, configurationNix ? import ./configuration-nix.nix
}:

self: # Provided by `callPackageWithOutput`

let

  inherit (stdenv.lib) extends makeExtensible;
  inherit (import ./lib.nix { inherit pkgs; }) overrideCabal makePackageSet;

  haskellPackages = makePackageSet {
    package-set = initialPackages;
    extensible-self = self;
    inherit ghc;
  };

  commonConfiguration = configurationCommon { inherit pkgs; };
  nixConfiguration = configurationNix { inherit pkgs; };

in (extends overrides
     (extends packageSetConfig
       (extends compilerConfig
         (extends commonConfiguration
           (extends nixConfiguration haskellPackages))))) self
