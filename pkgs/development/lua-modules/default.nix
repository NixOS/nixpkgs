# inspired by pkgs/development/haskell-modules/default.nix
{ pkgs, lib
, lua
, overrides ? (final: prev: {})
}:

let

  inherit (lib) extends;

  initialPackages = (pkgs.callPackage ../../top-level/lua-packages.nix {
    inherit lua;
  });

  overridenPackages = import ./overrides.nix { inherit pkgs; };

  generatedPackages = if (builtins.pathExists ./generated-packages.nix) then
    (final: prev: pkgs.callPackage ./generated-packages.nix { inherit (final) callPackage; } final prev) else (final: prev: {});

  extensions = lib.composeManyExtensions [
    generatedPackages
    overridenPackages
    overrides
  ];

  extensible-self = lib.makeExtensible (lib.extends extensions initialPackages);

in
  extensible-self
