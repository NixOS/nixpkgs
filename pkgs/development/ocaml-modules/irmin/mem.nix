{ lib, buildDunePackage, irmin, irmin-test }:

buildDunePackage rec {

  pname = "irmin-mem";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [ irmin ];

  checkInputs = lib.optional doCheck irmin-test;

  doCheck = true;

  meta = irmin.meta // {
    description = "Generic in-memory Irmin stores";
  };

}
