{ stdenv, callPackage, fetchFromGitHub, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2019-08-11";
  git-version = "0.16-DEV-132-gcb58f9a3";
  gambit = gambit-unstable;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "cb58f9a30630a6f3e85a55f2c1dcc654f517ffed";
    sha256 = "18jh64v1gi6z3pks9zf19f2wcjpv21cs270dnaq617kgwp53vysh";
  };
  inherit stdenv;
}
