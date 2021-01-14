{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2021-06-08";
  git-version = "0.16-192-gfa9537be";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "fa9537be0848e54d2c68165503b9cc48babb9334";
    sha256 = "0jm331giq0m73l66xc9mjzzbvmg4jxqkmcxc68fjywrcxa07xx31";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
