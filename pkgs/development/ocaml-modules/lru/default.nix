{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  psq,
  qcheck-alcotest,
}:

buildDunePackage rec {
  pname = "lru";
  version = "0.3.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/pqwy/lru/releases/download/v${version}/lru-${version}.tbz";
    hash = "sha256-bL4j0np9WyRPhpwLiBQNR/cPQTpkYu81wACTJdSyNv0=";
  };

  propagatedBuildInputs = [ psq ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ qcheck-alcotest ];

  meta = with lib; {
    homepage = "https://github.com/pqwy/lru";
    description = "Scalable LRU caches for OCaml";
    maintainers = [ maintainers.vbgl ];
    license = licenses.isc;
  };
}
