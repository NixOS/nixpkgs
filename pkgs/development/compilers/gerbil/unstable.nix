{ stdenv, callPackage, fetchFromGitHub, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2018-11-19";
  git-version = "0.15-DEV-2-g7d09a4ce";
  gambit = gambit-unstable;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "7d09a4cebe03d755a1791e77279e156a74e07685";
    sha256 = "1mqi9xcjk59sqbh1fx65a4fa4mqm35py4xqxq6086bcyhkm1nzwa";
  };
  inherit stdenv;
}
