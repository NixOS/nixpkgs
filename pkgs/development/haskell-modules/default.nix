{ pkgs, stdenv, lib, haskellLib, compiler, all-cabal-hashes
, buildCompiler, buildHaskellPackages
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
, initialPackages ? import ./initial-packages.nix
, configurationCommon ? import ./configuration-common.nix
, configurationNix ? import ./configuration-nix.nix
}:

let

  inherit (lib) extends makeExtensible;
  inherit (haskellLib) overrideCabal makePackageSet;

  haskellPackages = pkgs.callPackage makePackageSet {
    package-set = initialPackages;
    inherit stdenv haskellLib compiler buildCompiler buildHaskellPackages extensible-self all-cabal-hashes;
  };

  commonConfiguration = configurationCommon { inherit pkgs haskellLib; };
  nixConfiguration = configurationNix { inherit pkgs haskellLib; };

  extensible-self = makeExtensible
    (extends overrides
      (extends packageSetConfig
        (extends compilerConfig
          (extends commonConfiguration
            (extends nixConfiguration haskellPackages)))));

in

  extensible-self
