
{ pkgs, newScope }:

let
  callPackage = newScope self;

  self = rec {
      platformio-chrootenv = callPackage ./chrootenv.nix { };
  };

in self
