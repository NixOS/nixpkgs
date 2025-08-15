{
  callPackage,
  fetchFromGitHub,
  gambit-support,
}:

callPackage ./build.nix rec {
  version = "unstable-2025-05-13";
  git-version = "0.18.1";
  src = fetchFromGitHub {
    owner = "mighty-gerbils";
    repo = "gerbil";
    rev = "e55e0806a77f7364c649dbd99ada5972b6f90689";
    hash = "sha256-Omy+JyJx/Rke1G2d+wYcQpQWvYAnPAbNYYuLC+NXcw4=";
    fetchSubmodules = true;
  };
  inherit gambit-support;
  gambit-params = gambit-support.unstable-params;
  # These are available in pkgs.gambit-unstable.passthru.git-version, etc.
  gambit-git-version = "4.9.6-17-gdc315982";
  gambit-stampYmd = "20250510";
  gambit-stampHms = "115400";
}
