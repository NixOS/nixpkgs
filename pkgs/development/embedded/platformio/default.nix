{
  newScope,
  fetchFromGitHub,
  python3Packages,
}:

let
  callPackage = newScope self;

  self = {
    platformio-core = python3Packages.callPackage ./core.nix { };

    platformio-chrootenv = callPackage ./chrootenv.nix { };
  };

in
self
