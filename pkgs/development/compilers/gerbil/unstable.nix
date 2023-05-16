{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
<<<<<<< HEAD
  version = "unstable-2023-08-07";
  git-version = "0.17.0-187-gba545b77";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "ba545b77e8e85118089232e3cd263856e414b24b";
    sha256 = "1f4v1qawx2i8333kshj4pbj5r21z0868pwrr3r710n6ng3pd9gqn";
=======
  version = "unstable-2020-11-05";
  git-version = "0.16-152-g808929ae";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "808929aeb8823959191f35df53bc0c0150911b4b";
    sha256 = "0d9k2gkrs9qvlnk7xa3gjzs3gln3ydds7yd2313pvbw4q2lcz8iw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
