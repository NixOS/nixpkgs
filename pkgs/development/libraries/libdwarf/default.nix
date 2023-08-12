{ callPackage, zlib }:
callPackage ./common.nix rec {
  version = "0.4.2";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  sha512 = "6d2a3ebf0104362dd9cecec272935684f977db119810eea0eec88c9f56a042f260a4f6ed3bbabde8592fe16f98cbd81b4ab2878005140e05c8f475df6380d1c2";
  buildInputs = [ zlib ];
  knownVulnerabilities = [];
}
