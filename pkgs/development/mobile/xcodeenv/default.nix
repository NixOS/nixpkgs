{stdenv}:

rec {
  xcodewrapper = import ./xcodewrapper.nix {
    inherit stdenv;
  };

  buildApp = import ./build-app.nix {
    inherit stdenv xcodewrapper;
  };

  simulateApp = import ./simulate-app.nix {
    inherit stdenv xcodewrapper;
  };
}
