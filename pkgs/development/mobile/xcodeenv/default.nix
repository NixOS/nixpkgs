{stdenv, version ? "6.1.1", xcodeBaseDir ? "/Applications/Xcode.app"}:

rec {
  xcodewrapper = import ./xcodewrapper.nix {
    inherit stdenv version xcodeBaseDir;
  };

  buildApp = import ./build-app.nix {
    inherit stdenv xcodewrapper;
  };

  simulateApp = import ./simulate-app.nix {
    inherit stdenv xcodewrapper;
  };
}
