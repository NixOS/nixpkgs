{ stdenv, callPackage, fetchFromGitHub }:

callPackage ./build.nix {
  version = "unstable-2018-11-19";
# git-version = "4.9.1-8-g61c6cb50";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "61c6cb500f4756be1e52095d5ab4501752525a70";
    sha256 = "1knpb40y1g09c6yqd2fsxm3bk56bl5xrrwfsd7nqa497x6ngm5pn";
  };
  inherit stdenv;
}
