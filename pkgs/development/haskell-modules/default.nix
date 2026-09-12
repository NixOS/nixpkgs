{
  pkgs,
  stdenv,
  lib,
  haskellLib,
  ghc,
  all-cabal-hashes,
  buildHaskellPackages,
  # See `alwaysSplice` in ./make-package-set.nix.
  alwaysSplice ? false,
  compilerConfig ? (self: super: { }),
  packageSetConfig ? (self: super: { }),
  overrides ? (self: super: { }),
  initialPackages ? import ./initial-packages.nix,
  nonHackagePackages ? import ./non-hackage-packages.nix,
  configurationCommon ? import ./configuration-common.nix,
  configurationNix ? import ./configuration-nix.nix,
  configurationArm ? import ./configuration-arm.nix,
  configurationDarwin ? import ./configuration-darwin.nix,
  configurationWindows ? import ./configuration-windows.nix,
  configurationJS ? import ./configuration-ghcjs-9.x.nix,
}:

let

  inherit (lib) extends makeExtensible;
  inherit (haskellLib) makePackageSet;

  haskellPackages = pkgs.callPackage makePackageSet {
    package-set = initialPackages;
    inherit
      stdenv
      haskellLib
      ghc
      extensible-self
      all-cabal-hashes
      buildHaskellPackages
      alwaysSplice
      ;
  };

  platformConfigurations =
    lib.optionals stdenv.hostPlatform.isAarch [
      (configurationArm { inherit pkgs haskellLib; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (configurationDarwin { inherit pkgs haskellLib; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isWindows [
      (configurationWindows { inherit pkgs haskellLib; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isGhcjs [
      (configurationJS { inherit pkgs haskellLib; })
    ];

  extensions = lib.composeManyExtensions (
    [
      (nonHackagePackages { inherit pkgs haskellLib; })
      (configurationNix { inherit pkgs haskellLib; })
      (configurationCommon { inherit pkgs haskellLib; })
    ]
    ++ platformConfigurations
    ++ [
      compilerConfig
      packageSetConfig
      overrides
    ]
  );

  extensible-self = makeExtensible (extends extensions haskellPackages);

in

extensible-self
