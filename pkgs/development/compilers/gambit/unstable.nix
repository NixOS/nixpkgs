{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2023-07-30";
  git-version = "4.9.5-3-ge059fffd";
  stampYmd = 20230730;
  stampHms = 151945;
  src = fetchFromGitHub {
    owner = "gambit";
    repo = "gambit";
    rev = "e059fffdfbd91e27c350ff2ebd671adefadd5212";
    sha256 = "0q7hdfchl6lw53xawmmjvhyjdmqxjdsnzjqv9vpkl2qa4vyir5fs";
  };
  gambit-params = gambit-support.unstable-params;
}
