{ lib, pkgs, overrides ? (self: super: { }) }:

let
  inside = self:
    let callPackage = pkgs.newScope self;
    in rec {

      buildFactorApplication = callPackage ./mk-factor-application.nix {};

      factor-unwrapped = callPackage ./unwrapped.nix { };

      factor-lang = callPackage ./wrapper.nix { };
      factor-no-gui = callPackage ./wrapper.nix { guiSupport = false; };
      factor-minimal = callPackage ./wrapper.nix {
        enableDefaults = false;
        guiSupport = false;
      };
    };
  extensible-self = lib.makeExtensible (lib.extends overrides inside);
in
extensible-self
