{ pkgs, stdenv, lib, haskellLib, ghc, all-cabal-hashes
, buildHaskellPackages
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
    inherit stdenv haskellLib ghc buildHaskellPackages extensible-self all-cabal-hashes;
  };

  # Create core library set. Each library listed in the GHC compiler’s
  # libraries passthru is mapped to a scrapped package.
  coreLibraries = self: super: let
  # Make a derivation that is just a copy of one of GHC’s core
  # libraries. This is done to prevent stuff built by GHC from
  # referencing GHC itself.
  mkCoreLib = ghc: pkg: rec {
    inherit (builtins.parseDrvName pkg) name;
    value = pkgs.runCommand pkg (lib.optionalAttrs (name == "base") {
      propagatedBuildInputs = [ self.rts ];
    }) ''
      install -D ${ghc}/lib/${ghc.name}/package.conf.d/${pkg}.conf \
                 $out/lib/${ghc.name}/package.conf.d/${pkg}.conf
      cp -r ${ghc}/lib/${ghc.name}/${pkg} $out/lib/${ghc.name}
      ${lib.optionalString (name == "rts")
            "cp -r ${ghc}/lib/${ghc.name}/include $out/lib/${ghc.name}"}
      for conf in $out/lib/${ghc.name}/package.conf.d/*.conf; do
        substituteInPlace $conf --replace ${ghc} $out
      done

      eval fixupPhase
    '';
  }; in builtins.listToAttrs (map (mkCoreLib ghc) (super.ghc.libraries or []));

  commonConfiguration = configurationCommon { inherit pkgs haskellLib; };
  nixConfiguration = configurationNix { inherit pkgs haskellLib; };

  extensible-self = makeExtensible
    (extends overrides
      (extends packageSetConfig
        (extends compilerConfig
          (extends coreLibraries
            (extends commonConfiguration
              (extends nixConfiguration haskellPackages))))));

in

  extensible-self
