{ lib, pkgs
, overrides ? (self: super: {})}:

let
  inside = (self:
  let callPackage = pkgs.newScope self;
  in rec {
    interpreter = callPackage ./factor99.nix { inherit (pkgs) stdenv; };

    # Convenience access for using the returned attribute the same way as the
    # interpreter derivation. Takes a list of runtime libraries as its only
    # argument.
    inherit (self.interpreter) withLibs;
  });
  extensible-self = lib.makeExtensible (lib.extends overrides inside);
in extensible-self
