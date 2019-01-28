{ stdenv, callPackage, fetchFromGitHub, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2019-01-25";
  git-version = "0.15";
  gambit = gambit-unstable;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "8c1aa2ca129a380de9cf668a7f3f6d56e56cbf94";
    sha256 = "1ff1gpl0bl1pbs68bxax82ikw4bzbkrj4a6l775ziwyfndjggl66";
  };
  inherit stdenv;
}
