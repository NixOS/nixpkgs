{ pkgs, stdenv, ghc, all-cabal-hashes
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
, initialPackages ? import ./hackage-packages.nix
, configurationCommon ? import ./configuration-common.nix
, configurationNix ? import ./configuration-nix.nix
}:

let

  inherit (stdenv.lib) extends makeExtensible;
  inherit (import ./lib.nix { inherit pkgs; }) overrideCabal makePackageSet;

  haskellPackages = makePackageSet {
    package-set = initialPackages;
    inherit ghc extensible-self;
  };

  commonConfiguration = configurationCommon { inherit pkgs; };
  nixConfiguration = configurationNix { inherit pkgs; };

  extensible-self = makeExtensible
    (extends overrides
      (extends packageSetConfig
        (extends compilerConfig
          (extends commonConfiguration
            (extends nixConfiguration haskellPackages)))));

in

  extensible-self
