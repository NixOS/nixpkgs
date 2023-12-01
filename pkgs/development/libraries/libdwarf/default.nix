{ callPackage, zlib }:
callPackage ./common.nix rec {
  version = "0.4.2";
  url = "https://www.prevanders.net/libdwarf-${version}.tar.xz";
  hash = "sha512-bSo+vwEENi3Zzs7CcpNWhPl32xGYEO6g7siMn1agQvJgpPbtO7q96Fkv4W+Yy9gbSrKHgAUUDgXI9HXfY4DRwg==";
  buildInputs = [ zlib ];
  knownVulnerabilities = [];
}
