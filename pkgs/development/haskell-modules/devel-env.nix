# This expression results in a function that sets up
# a development environment.

{ # package-set used for non-haskell dependencies (all of nixpkgs)
  pkgs

, # haskell packages
  packages
}:

# configuration parameters of development environment
#
# example:
#
# {
#   compilers = {
#     ghcHEAD = {
#       cabal-roots = [ ./. ];
#       source-overrides = { pipes = 0.5.1; };
#       extra-packages = p: [ p.intero ];
#     };
#     ghcjsHEAD = {
#       cabal-roots = [ ./. ];
#     };
#   };
#
#   common = {
#     extra-packages = p: [ p.hspec ];
#     package-tweaks = with pkgs.haskell.lib; { servant = doJailbreak; };
#   };
#
#   extra-pkgs = [
#     pkgs.cabal-install
#     pkgs.stack
#   ];
# }
config_arg:

let
  applyTweaks = x: self: pkgs.lib.mapAttrs (n: v: v (builtins.getAttr n self)) x;

  verifyParameters =
   { name ? "Haskell-development-environment"
   , compilers ? {}
   , common ? {}
   , extra-pkgs ? []
   }: { inherit name compilers common; extraPkgs = extra-pkgs; };

  verifyParametersCommon =
    { source-overrides ? {}
    , package-tweaks ? {}
    , defaults ? {}
    , extra-packages ? p:[]
    }: { inherit source-overrides defaults; overrides = applyTweaks package-tweaks; pkgsList = extra-packages; };

  verifyParametersCompiler =
    { cabal-roots ? []
    , source-overrides ? {}
    , package-tweaks ? {}
    , defaults ? {}
    , extra-packages ? p:[]
    }: { roots = cabal-roots; inherit source-overrides defaults; overrides = applyTweaks package-tweaks; pkgsList = extra-packages; };


  # monoid interface for exports of .../haskell-modules/generic-builder.nix
  emptyExport = {
    haskellBuildInputs=[];
    systemBuildInputs=[];
    pnames=[];
  };
  appendExport = a: b: {
    haskellBuildInputs = a.haskellBuildInputs ++ b.haskellBuildInputs;
    systemBuildInputs = a.systemBuildInputs ++ b.systemBuildInputs;
    pnames = a.pnames ++ b.pnames;
  };


  # implementation

  input = verifyParameters config_arg;
  common = verifyParametersCommon input.common;

  # for nix-build
  buildPackages = n: v:
    let
      verified = verifyParametersCompiler v;
      haskellPackages = packages.${n}.extendHaskellPackages {
        overrides = (x: { mkDerivation = y: x.mkDerivation (y // common.defaults // verified.defaults); } // common.overrides x // verified.overrides x);
        source-overrides = common.source-overrides // verified.source-overrides;
      };
      releases = pkgs.lib.foldr
         (x: a: let p = haskellPackages.callCabal2nix (builtins.baseNameOf x) x {}; in a // { ${p.pname} = p; })
         {} verified.roots;
    in
      pkgs.lib.genAttrs (builtins.attrNames releases) (x: builtins.getAttr x (haskellPackages.extend (_: _: releases)));


  # for nix-shell
  baseHaskellPackages = pkgs.lib.mapAttrsToList (n: v:
    let
      verified = verifyParametersCompiler v;
    in {
      haskellPackages = packages.${n}.extendHaskellPackages {
        overrides = (x: { mkDerivation = y: x.mkDerivation (y // common.defaults // verified.defaults); } // common.overrides x // verified.overrides x);
        source-overrides = common.source-overrides // verified.source-overrides;
      };
      inherit (verified) roots pkgsList;
    }
  ) input.compilers;

  exports = builtins.map (
    { haskellPackages, roots, pkgsList }:
    {
      inherit haskellPackages roots pkgsList;
    } // (
      pkgs.lib.foldr
        (x: a: appendExport a (haskellPackages.callCabal2nix (builtins.baseNameOf x) x {}).export)
        emptyExport roots
    )
  ) baseHaskellPackages;

  localPackages = pkgs.lib.foldr (x: a: a ++ x.pnames) [] exports;

  uniquePname = list:
    if list == []
    then []
    else
      let
        x = pkgs.lib.head list;
        xs = uniquePname (pkgs.lib.drop 1 list);
      in
        [x] ++ builtins.filter (y: y.pname != x.pname) xs;

  filteredExports = builtins.map (x:
    {
      inherit (x) haskellPackages roots systemBuildInputs pkgsList;
      haskellBuildInputs = uniquePname (
        builtins.filter
         (y: !(builtins.elem y.pname localPackages))
         (x.haskellBuildInputs ++ (y: common.pkgsList y ++ x.pkgsList y) x.haskellPackages)
      );
    }
  ) exports;

  compilerEnvs = builtins.map (x:
    { inherit (x) haskellPackages roots;
      ghcEnv = x.haskellPackages.ghc.withPackages (p: x.haskellBuildInputs);
    }
  ) filteredExports;

  systemBuildInputs = pkgs.lib.foldr (x: a: a ++ x.systemBuildInputs) [] exports;

  mkCompilerShellHook = { haskellPackages, ghcEnv, ... }:
    let
      ghc = haskellPackages.ghc;
      ghcCommand' = if (ghc.isGhcjs or false) then "ghcjs" else "ghc";
      crossPrefix = if (ghc.cross or null) != null then "${ghc.cross.config}-" else "";
      ghcCommand = "${crossPrefix}${ghcCommand'}";
      ghcCommandCaps= pkgs.stdenv.lib.toUpper ghcCommand';
    in ''
      export NIX_${ghcCommandCaps}="${ghcEnv}/bin/${ghcCommand}"
      export NIX_${ghcCommandCaps}PKG="${ghcEnv}/bin/${ghcCommand}-pkg"
      # TODO: is this still valid?
      export NIX_${ghcCommandCaps}_DOCDIR="${ghcEnv}/share/doc/ghc/html"
    '';

  mkLDLIBRARYShellHook = ''
    export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+''${LD_LIBRARY_PATH}:}${
      pkgs.stdenv.lib.makeLibraryPath (builtins.filter (x: !isNull x) systemBuildInputs)
    }"
  '';

  shellHook = "\n" + mkLDLIBRARYShellHook + "\n" + pkgs.lib.foldr (x: a: a + x) "" (builtins.map mkCompilerShellHook compilerEnvs);

  develEnv = pkgs.stdenv.mkDerivation {
    inherit (input) name;
    LANG = "en_US.UTF-8";
    LOCALE_ARCHIVE = pkgs.lib.optionalString pkgs.stdenv.isLinux "${pkgs.glibcLocales}/lib/locale/locale-archive";
    nativeBuildInputs = (builtins.map (builtins.getAttr "ghcEnv") compilerEnvs) ++ [ systemBuildInputs ] ++ input.extraPkgs;
    inherit shellHook;
  };

in
  if pkgs.lib.inNixShell
  then develEnv
  else (pkgs.lib.mapAttrs buildPackages input.compilers) // { devel = develEnv; }

