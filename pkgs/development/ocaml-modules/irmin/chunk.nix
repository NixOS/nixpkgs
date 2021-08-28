{ lib, buildDunePackage, irmin, irmin-test, alcotest }:

buildDunePackage rec {

  pname = "irmin-chunk";
  inherit (irmin) version src useDune2;

  propagatedBuildInputs = [ irmin ];

  doCheck = true;
  checkInputs = [ alcotest irmin-test ];

  meta = irmin.meta // {
    description = "Irmin backend which allow to store values into chunks";
  };

}

