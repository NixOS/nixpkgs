{ stdenv, callPackage, fetchFromGitHub }:

callPackage ./build.nix {
  version = "unstable-2020-02-24";
# git-version = "4.9.3-979-gc69e9f70";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "c69e9f70dfdc6545353b135a5d5e2f9234f1e1cc";
    sha256 = "1f69n7yzzdv3wpnjlrbck38xpa8115vbady43mc544l39ckklr0k";
  };
  inherit stdenv;
}
