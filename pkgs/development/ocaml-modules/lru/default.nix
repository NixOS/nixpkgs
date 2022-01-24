{ lib, fetchurl, buildDunePackage, ocaml, psq, qcheck-alcotest }:

buildDunePackage rec {
  pname = "lru";
  version = "0.3.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/pqwy/lru/releases/download/v${version}/lru-v${version}.tbz";
    sha256 = "1ab9rd7cq15ml8x0wjl44wy99h5z7x4g9vkkz4i2d7n84ghy7vw4";
  };

  propagatedBuildInputs = [ psq ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ qcheck-alcotest ];

  meta = {
    homepage = "https://github.com/pqwy/lru";
    description = "Scalable LRU caches for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.isc;
  };
}
