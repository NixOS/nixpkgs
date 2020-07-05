{ lib, buildDunePackage, alcotest-lwt, index, irmin, irmin-test, ocaml_lwt }:

buildDunePackage rec {
  minimumOCamlVersion = "4.02.3";

  pname = "irmin-pack";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [ index irmin ocaml_lwt ];

  checkInputs = lib.optionals doCheck [ alcotest-lwt irmin-test ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Irmin backend which stores values in a pack file";
  };

}
