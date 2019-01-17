# inspired by pkgs/development/haskell-modules/default.nix
{ pkgs, stdenv, lib
, lua

, overrides ? (self: super: {})
, initialPackages ? import ../../initial-packages.nix
, nonLuarocksPackages ? import ./non-luarocks-packages.nix
, configurationCommon ? import ./overrides.nix
}:

let

  inherit (lib) extends makeExtensible;
  # inherit (haskellLib) makePackageSet;

  # luarocks ?
  # luaPackages = pkgs.callPackage makePackageSet {
  #   package-set = initialPackages;
  #   inherit stdenv haskellLib ghc buildHaskellPackages extensible-self all-cabal-hashes;
  # };

# # Applying this to an attribute set will cause nix-env to look
  # # inside the set for derivations.
  # recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  # recurseIntoAttrs
  initialPackages = (pkgs.callPackage ../../top-level/lua-packages.nix {
    inherit lua;
    # inherit buildLuaPackage;
  });

  commonConfiguration = configurationCommon { inherit pkgs; };
  # nixConfiguration = configurationNix { inherit pkgs haskellLib; };

  generatedPackages = pkgs.callPackage ./generated-packages.nix { };
  # generatedPackages = if (builtins.pathExists ./generated-packages.nix) then
  #       pkgs.callPackage ./generated-packages.nix { } else (self: super: {});

  extensible-self = makeExtensible
    (extends overrides
        (extends commonConfiguration
          (extends generatedPackages
              # (extends nonLuarocksPackages
              initialPackages
              )
          )
    )
          ;
in
  extensible-self
  # initialPackages
