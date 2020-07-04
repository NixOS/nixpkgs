{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2020-05-17";
  git-version = "0.16-1-g36a31050";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "36a31050f6c80e7e1a49dfae96a57b2ad0260698";
    sha256 = "0k3fypam9qx110sjxgzxa1mdf5b631w16s9p5v37cb8ll26vqfiv";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
