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

  initialPackages = (pkgs.callPackage ../../top-level/lua-packages.nix {
    inherit lua;
  });

  commonConfiguration = configurationCommon { inherit pkgs; };

  # when the generation of the file fails, just remove it
  generatedPackages = if (builtins.pathExists ./generated-packages.nix) then
    pkgs.callPackage ./generated-packages.nix { }
    else lib.warn "Missing lua generated-packages" (self: super: {});

  extensible-self = makeExtensible
    (extends overrides
        (extends commonConfiguration
          (extends generatedPackages
              initialPackages
              )
          )
    )
          ;
in
  extensible-self
