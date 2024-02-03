{ callPackage }:

rec {
  composeXcodeWrapper = callPackage ./compose-xcodewrapper.nix { };

  buildApp = callPackage ./build-app.nix { inherit composeXcodeWrapper; };

  simulateApp = callPackage ./simulate-app.nix { inherit composeXcodeWrapper; };
}
