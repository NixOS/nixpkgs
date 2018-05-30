{ callPackage, fetchgit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2018-05-12";
  git-version = "0.13-DEV-437-gaefdb47f";
  GAMBIT = gambit-unstable;
  SRC = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "aefdb47f3d1ceaa735fd5c3dcaac2aeb0d4d2436";
    sha256 = "0xhsilm5kix5lsmykv273npp1gk6dgx9axh266mimwh7j0nxf7ms";
  };
}
