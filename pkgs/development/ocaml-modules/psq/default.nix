{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  seq,
  qcheck-alcotest,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.03";
  pname = "psq";
  version = "0.2.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/pqwy/psq/releases/download/v${version}/psq-${version}.tbz";
    hash = "sha256-QgBfUz6r50sXme4yuJBWVM1moivtSvK9Jmso2EYs00Q=";
  };

  propagatedBuildInputs = [ seq ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ qcheck-alcotest ];

  meta = {
    description = "Functional Priority Search Queues for OCaml";
    homepage = "https://github.com/pqwy/psq";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.isc;
  };
}
