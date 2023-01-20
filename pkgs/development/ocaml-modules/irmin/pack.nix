{ lib, buildDunePackage
, alcotest-lwt, index, irmin, irmin-layers, irmin-test, ocaml_lwt, fpath, optint
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.02.3";

  pname = "irmin-pack";

  inherit (irmin) version src;

  useDune2 = true;

  buildInputs = [ fpath ];
  propagatedBuildInputs = [ index irmin irmin-layers ocaml_lwt optint ];

  checkInputs = [ alcotest-lwt irmin-test ];

  # Check fails with cmdliner ≥ 1.1
  doCheck = false;

  meta = irmin.meta // {
    description = "Irmin backend which stores values in a pack file";
    mainProgram = "irmin_fsck";
  };

}
