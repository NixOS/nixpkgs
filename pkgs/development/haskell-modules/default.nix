{ pkgs, stdenv, lib, haskellLib, ghc, all-cabal-hashes
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
, initialPackages ? import ./hackage-packages.nix
, configurationCommon ? import ./configuration-common.nix
, configurationNix ? import ./configuration-nix.nix
}:

self: # Provided by `callPackageWithOutput`

let

  inherit (lib) extends makeExtensible;
  inherit (haskellLib) overrideCabal makePackageSet;

  haskellPackages = pkgs.callPackage makePackageSet {
    package-set = initialPackages;
    extensible-self = self;
    inherit stdenv haskellLib ghc;
  };

  commonConfiguration = configurationCommon { inherit pkgs haskellLib; };
  nixConfiguration = configurationNix { inherit pkgs haskellLib; };

in (extends overrides
     (extends packageSetConfig
       (extends compilerConfig
         (extends commonConfiguration
           (extends nixConfiguration haskellPackages))))) self
