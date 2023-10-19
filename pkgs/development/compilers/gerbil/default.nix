{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support, pkgs, gccStdenv }:

callPackage ./build.nix rec {
  version = "0.18";
  git-version = "0.18";
  src = fetchFromGitHub {
    owner = "mighty-gerbils";
    repo = "gerbil";
    rev = "8ca36a928bc9345f9d28e5f2dfcb55ca558e85f9";
    sha256 = "sha256-EMiYgQM/Gl+dh6AxLYRZ0BKZ+VKFd+Lkyy9Pw11ivE8=";
    fetchSubmodules = true;
  };
  inherit gambit-support;
  gambit-params = gambit-support.unstable-params;
  gambit-git-version = "4.9.5-40-g24201248"; # pkgs.gambit-unstable.passthru.git-version
  gambit-stampYmd = "20230917"; # pkgs.gambit-unstable.passthru.git-stampYmd
  gambit-stampHms = "182043"; # pkgs.gambit-unstable.passthru.git-stampHms
}
