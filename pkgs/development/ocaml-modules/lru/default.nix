{ lib, fetchurl, buildDunePackage, psq }:

buildDunePackage rec {
  pname = "lru";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/pqwy/lru/releases/download/v${version}/lru-v${version}.tbz";
    sha256 = "1ab9rd7cq15ml8x0wjl44wy99h5z7x4g9vkkz4i2d7n84ghy7vw4";
  };

  propagatedBuildInputs = [ psq ];

  meta = {
    homepage = "https://github.com/pqwy/lru";
    description = "Scalable LRU caches for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.isc;
  };
}
