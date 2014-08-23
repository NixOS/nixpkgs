{stdenv, version ? "5.0"}:

rec {
  xcodewrapper = import ./xcodewrapper.nix {
    inherit stdenv version;
  };

  buildApp = import ./build-app.nix {
    inherit stdenv xcodewrapper;
  };

  simulateApp = import ./simulate-app.nix {
    inherit stdenv xcodewrapper;
  };
}
