{
  callPackage,
  fetchFromGitHub,
  gambit-support,
}:

callPackage ./build.nix rec {
  version = "4.9.8-unstable-2026-08-15";
  git-version = "v4.9.8-3-g2c1accee";
  stampYmd = 20260815;
  stampHms = 191450;
  rev = "2c1acceed6ccf1895d9aaf9b03c7a836ce2cc59d";
  src = fetchFromGitHub {
    owner = "gambit";
    repo = "gambit";
    inherit rev;
    hash = "sha256-VYt7eH4c3CA66a3InF2EJ9vzkeJMpvN4WZjNW4tQlAM=";
  };
  gambit-params = gambit-support.unstable-params;
}
