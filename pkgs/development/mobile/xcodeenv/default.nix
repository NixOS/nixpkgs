{ stdenv, lib }:

rec {
  composeXcodeWrapper = import ./compose-xcodewrapper.nix {
    inherit stdenv;
  };

  buildApp = import ./build-app.nix {
    inherit stdenv lib composeXcodeWrapper;
  };

  simulateApp = import ./simulate-app.nix {
    inherit stdenv lib composeXcodeWrapper;
  };
}
