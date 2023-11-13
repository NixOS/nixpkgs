{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2023-08-07";
  git-version = "0.17.0-187-gba545b77";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "ba545b77e8e85118089232e3cd263856e414b24b";
    sha256 = "1f4v1qawx2i8333kshj4pbj5r21z0868pwrr3r710n6ng3pd9gqn";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
