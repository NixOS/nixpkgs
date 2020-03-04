{ lib, buildDunePackage, alcotest-lwt, index, irmin, irmin-test }:

buildDunePackage rec {

  pname = "irmin-pack";

  inherit (irmin) version src;

  propagatedBuildInputs = [ index irmin ];

  checkInputs = lib.optionals doCheck [ alcotest-lwt irmin-test ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Irmin backend which stores values in a pack file";
  };

}
