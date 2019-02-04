# inspired by pkgs/development/haskell-modules/default.nix
{ pkgs, stdenv, lib
, lua
, overrides ? (self: super: {})
}:

let

  inherit (lib) extends;

  initialPackages = (pkgs.callPackage ../../top-level/lua-packages.nix {
    inherit lua;
  });

  overridenPackages = import ./overrides.nix { inherit pkgs; };

  generatedPackages = if (builtins.pathExists ./generated-packages.nix) then
        pkgs.callPackage ./generated-packages.nix { } else (self: super: {});

  extensible-self = lib.makeExtensible
    (extends overrides
        (extends overridenPackages
          (extends generatedPackages
              initialPackages
              )
          )
    )
          ;
in
  extensible-self
