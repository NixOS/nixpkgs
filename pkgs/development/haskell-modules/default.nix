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
, configurationDarwin ? import ./configuration-darwin.nix
}:

let

  inherit (lib) extends makeExtensible;
  inherit (haskellLib) makePackageSet;

  haskellPackages = pkgs.callPackage makePackageSet {
    package-set = initialPackages;
    inherit stdenv haskellLib ghc buildHaskellPackages extensible-self all-cabal-hashes;
  };

  platformConfigurations = lib.optionals stdenv.hostPlatform.isAarch [
    (configurationArm { inherit pkgs haskellLib; })
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (configurationDarwin { inherit pkgs haskellLib; })
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
