{ pkgs, stdenv, lib, haskellLib, ghc, all-cabal-hashes
, buildHaskellPackages
, compilerConfig ? (self: super: {})
, packageSetConfig ? (self: super: {})
, overrides ? (self: super: {})
, initialPackages ? import ./initial-packages.nix
, nonHackagePackages ? import ./non-hackage-packages.nix
, configurationCommon ? import ./configuration-common.nix
, configurationNix ? import ./configuration-nix.nix
, configurationArm ? import ./configuration-arm.nix
}:

let

  inherit (lib) extends makeExtensible;
  inherit (haskellLib) makePackageSet;

  haskellPackages = pkgs.callPackage makePackageSet {
    package-set = initialPackages;
    inherit stdenv haskellLib ghc buildHaskellPackages extensible-self all-cabal-hashes;
  };

  isArm = with stdenv.hostPlatform; isAarch64 || isAarch32;
  platformConfigurations = lib.optionals isArm [
    (configurationArm { inherit pkgs haskellLib; })
  ];

  extensions = lib.composeManyExtensions ([
    nonHackagePackages
    (configurationNix { inherit pkgs haskellLib; })
    (configurationCommon { inherit pkgs haskellLib; })
  ] ++ platformConfigurations ++ [
    compilerConfig
    packageSetConfig
    overrides
  ]);

  extensible-self = makeExtensible (extends extensions haskellPackages);

in

  extensible-self
