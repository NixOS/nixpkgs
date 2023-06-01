{ lib, fetchurl, buildDunePackage
, dscheck
, qcheck, qcheck-alcotest
}:

buildDunePackage rec {
  pname = "lockfree";
  version = "0.3.0";

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/lockfree/releases/download/${version}/lockfree-${version}.tbz";
    hash = "sha256-XdJR5ojFsA7bJ4aZ5rh10NjopE0NjfqQ9KitOLMh3Jo=";
  };

  propagatedBuildInputs = [ dscheck ];

  doCheck = true;
  checkInputs = [ qcheck qcheck-alcotest ];

  meta = {
    description = "Lock-free data structures for multicore OCaml";
    homepage = "https://github.com/ocaml-multicore/lockfree";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
