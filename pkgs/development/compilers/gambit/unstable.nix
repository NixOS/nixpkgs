{ stdenv, callPackage, fetchFromGitHub }:

callPackage ./build.nix {
  version = "unstable-2019-07-21";
# git-version = "4.9.3-109-g3b5f74fa";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "3b5f74fae74b2159e3bf6923f29a18b31cc15dcc";
    sha256 = "07cb0d8754dqhxawkp5dp4y0bsa9kfald4dkj60j5yfnsp81y5mi";
  };
  inherit stdenv;
}
