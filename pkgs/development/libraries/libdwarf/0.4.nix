{ callPackage, zlib }:
callPackage ./common.nix rec {
  version = "0.4.1";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  sha512 = "793fe487de80fe6878f022b90f49ec334a0d7db071ff22a11902db5e3457cc7f3f853945a9ac74de2c40f7f388277f21c5b2e62745bca92d2bb55c51e9577693";
  buildInputs = [ zlib ];
  knownVulnerabilities = [];
}
