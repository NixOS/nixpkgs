{stdenv, version ? "8.2.1", xcodeBaseDir ? "/Applications/Xcode.app"}:

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
