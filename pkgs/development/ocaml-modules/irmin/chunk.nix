{ lib, buildDunePackage, irmin, irmin-test, alcotest }:

buildDunePackage rec {

  pname = "irmin-chunk";
  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [ irmin ];

  buildInputs = checkInputs; # dune builds tests at build-time

  doCheck = true;
  checkInputs = [ alcotest irmin-test ];

  meta = irmin.meta // {
    description = "Irmin backend which allow to store values into chunks";
  };

}

