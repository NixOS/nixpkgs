{stdenv}:

rec {
  composeXcodeWrapper = import ./compose-xcodewrapper.nix {
    inherit stdenv;
  };

  buildApp = import ./build-app.nix {
    inherit stdenv composeXcodeWrapper;
  };

  simulateApp = import ./simulate-app.nix {
    inherit stdenv composeXcodeWrapper;
  };
}
