# inspired by pkgs/development/haskell-modules/default.nix
{ pkgs, stdenv, lib
, lua
, overrides ? (self: super: {})
}:

let

  inherit (lib) extends makeExtensible;

  initialPackages = (pkgs.callPackage ../../top-level/lua-packages.nix {
    inherit lua;
  });

  extensible-self = makeExtensible initialPackages;
in
  extensible-self
