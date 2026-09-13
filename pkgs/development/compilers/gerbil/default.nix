{
  callPackage,
  fetchFromGitHub,
  gambit-support,
}:

callPackage ./build.nix rec {
  version = "0.18.1";
  git-version = "0.18.1";
  src = fetchFromGitHub {
    owner = "mighty-gerbils";
    repo = "gerbil";
    rev = "23c30a6062cd7e63f9d85300ce01585bb9035d2d";
    sha256 = "15fh0zqkmnjhan1mgymq5fgbjsh5z9d2v6zjddplqib5zd2s3z6k";
    fetchSubmodules = true;
  };
  inherit gambit-support;
  gambit-params = gambit-support.unstable-params;
  gambit-git-version = "v4.9.8-3-g2c1accee";
  gambit-stampYmd = "20260815";
  gambit-stampHms = "191450";
}
