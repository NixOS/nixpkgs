{ stdenv, callPackage, fetchFromGitHub, gambit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2019-11-15";
  git-version = "0.15.1-461-gee22de62";
  #gambit = gambit-unstable;
  gambit = gambit;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "ee22de628a656ee59c6c72bc25d7b2e25a4ece2f";
    sha256 = "1n1j596b91k9xcmv22l72nga6wv20bka2q51ik2jw2vkcw8zkc1c";
  };
  inherit stdenv;
}
