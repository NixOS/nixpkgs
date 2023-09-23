{ lib, fetchurl, buildDunePackage, ocaml
, saturn_lockfree
, dscheck
, qcheck, qcheck-alcotest, qcheck-stm
}:

buildDunePackage rec {
  pname = "saturn";

  inherit (saturn_lockfree) src version;

  propagatedBuildInputs = [ saturn_lockfree ];

  doCheck = lib.versionAtLeast ocaml.version "5.0";
  checkInputs = [ dscheck qcheck qcheck-alcotest qcheck-stm ];

  meta = saturn_lockfree.meta // {
    description = "Parallelism-safe data structures for multicore OCaml";
  };

}
