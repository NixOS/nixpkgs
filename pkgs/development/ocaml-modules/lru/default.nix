{ lib, fetchurl, buildDunePackage, ocaml, psq, qcheck-alcotest }:

buildDunePackage rec {
  pname = "lru";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/pqwy/lru/releases/download/v${version}/lru-${version}.tbz";
    hash = "sha256-bL4j0np9WyRPhpwLiBQNR/cPQTpkYu81wACTJdSyNv0=";
  };

  propagatedBuildInputs = [ psq ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  nativeCheckInputs = [ qcheck-alcotest ];

  meta = {
    homepage = "https://github.com/pqwy/lru";
    description = "Scalable LRU caches for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.isc;
  };
}
