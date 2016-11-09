{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "1dsn0j6571dafvi2gdmbfndzmslw3p0fpbqpmlk34l1h4zsyql94";
  };
})
