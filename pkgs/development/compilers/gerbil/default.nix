{ stdenv, callPackage, fetchFromGitHub, gambit }:

callPackage ./build.nix rec {
  version = "0.15";
  git-version = "0.15";
  inherit gambit;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "v${version}";
    sha256 = "1ff1gpl0bl1pbs68bxax82ikw4bzbkrj4a6l775ziwyfndjggl66";
  };
  inherit stdenv;
}
