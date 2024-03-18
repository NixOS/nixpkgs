{ callPackage
, zlib
, zstd
}:

callPackage ./common.nix rec {
  version = "0.9.1";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  hash = "sha512-7Gbw28ct891omi04664CnggeDsMAjdUQNy4MLDh/AJLC+f6NmSje2HucLsMPHD3GO/rKfMShThyMVX08OzfSJw==";
  buildInputs = [ zlib zstd ];
  knownVulnerabilities = [];
}
