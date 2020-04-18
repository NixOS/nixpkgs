{ stdenv, callPackage, fetchFromGitHub, gambit }:

callPackage ./build.nix rec {
  version = "0.15.1";
  git-version = "0.15.1";
  inherit gambit;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "v${version}";
    sha256 = "0qpqms66hz41wwhxb1z0fnzj96ivkm7qi9h9d7lhlr3fsxm1kp1n";
  };
  inherit stdenv;
}
