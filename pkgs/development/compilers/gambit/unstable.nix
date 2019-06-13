{ stdenv, callPackage, fetchFromGitHub }:

callPackage ./build.nix {
  version = "unstable-2019-02-05";
# git-version = "4.9.3";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "baf7de67f6d800821412fe83a8d9e9e09faeb490";
    sha256 = "0ygm5y8fvq6dbb8mwq52v8rc8pdnwm4qpmxlnx5m9hzzbm1kzxxv";
  };
  inherit stdenv;
}
