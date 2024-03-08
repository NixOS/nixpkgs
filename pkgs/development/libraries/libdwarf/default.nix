{ callPackage
, zlib
, zstd
}:

callPackage ./common.nix rec {
  version = "0.9.0";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  hash = "sha512-KC2Q38nacE62SkuhFB8q5mD+6xS78acjdzhmmOMSSSi0SmkU2OiOYUGrCINc5yOtCQqFOtV9vLQ527pXJV+1iQ==";
  buildInputs = [ zlib zstd ];
  knownVulnerabilities = [];
}
