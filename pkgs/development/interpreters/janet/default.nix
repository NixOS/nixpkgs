{
  lib,
  newScope,
}:
lib.makeScope newScope (self: {
  janet = self.callPackage ./janet.nix { };

  janetHooks = self.callPackage ./hooks { };

  buildJanetBundle = self.callPackage ./bundle.nix { };

  jpm = self.callPackage ./jpm.nix { };
  spork = self.callPackage ./spork.nix { };
})
