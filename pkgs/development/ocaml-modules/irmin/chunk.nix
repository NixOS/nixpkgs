{ lib, buildDunePackage, irmin, irmin-mem, irmin-test }:

buildDunePackage rec {

  pname = "irmin-chunk";
  inherit (irmin) version src useDune2;

  propagatedBuildInputs = [ irmin ];

  doCheck = true;
  checkInputs = [ irmin-mem irmin-test ];

  meta = irmin.meta // {
    description = "Irmin backend which allow to store values into chunks";
  };

}

