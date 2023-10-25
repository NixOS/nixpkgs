{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support, pkgs, gccStdenv }:

callPackage ./build.nix rec {
  version = "unstable-2023-10-13";
  git-version = "0.18-2-g8ed012ff";
  src = fetchFromGitHub {
    owner = "mighty-gerbils";
    repo = "gerbil";
    rev = "8ed012ff9571fcfebcc07815813001a3f356150d";
    sha256 = "056kmjn7sd0hjwikmg7v3a1kvgsgvfi7pi9xcx3ixym9g3bqa4mx";
    fetchSubmodules = true;
  };
  inherit gambit-support;
  gambit-params = gambit-support.unstable-params;
  gambit-git-version = "4.9.5-40-g24201248"; # pkgs.gambit-unstable.passthru.git-version
  gambit-stampYmd = "20230917"; # pkgs.gambit-unstable.passthru.git-stampYmd
  gambit-stampHms = "182043"; # pkgs.gambit-unstable.passthru.git-stampHms
}
