{ newScope }:

let
  callPackage = newScope self;

  self = {
    platformio-core = callPackage ./core.nix { };

    platformio-chrootenv = callPackage ./chrootenv.nix { };
  };

in
self
