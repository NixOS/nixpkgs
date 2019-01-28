{ stdenv, callPackage, fetchFromGitHub }:

callPackage ./build.nix {
  version = "unstable-2019-01-18";
# git-version = "4.9.2";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "cf5688ecf35d85b9355c645f535c1e057b3064e7";
    sha256 = "1xr7j4iws6hlrdbvlii4n98apr78k4adbnmy4ggzyik65bynh1kl";
  };
  inherit stdenv;
}
