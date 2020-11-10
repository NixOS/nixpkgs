
{ newScope }:

let
  callPackage = newScope self;

  self = {
      platformio-chrootenv = callPackage ./chrootenv.nix { };
  };

in self
