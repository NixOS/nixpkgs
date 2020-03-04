{ stdenv, callPackage, fetchFromGitHub, gambit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2020-02-27";
  git-version = "0.16-DEV-493-g1ffb74db";
  #gambit = gambit-unstable;
  gambit = gambit;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "1ffb74db5ffd49b4bad751586cef5e619c891d41";
    sha256 = "1szmdp8lvy5gpcwn5bpa7x383m6vywl35xa7hz9a5vs1rq4w2097";
  };
  inherit stdenv;
}
