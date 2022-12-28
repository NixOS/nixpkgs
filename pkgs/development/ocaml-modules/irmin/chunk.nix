{ lib, buildDunePackage, irmin, irmin-test, fmt, logs, lwt, alcotest }:

buildDunePackage rec {

  pname = "irmin-chunk";
  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [ irmin fmt logs lwt ];

  doCheck = true;
  checkInputs = [ alcotest irmin-test ];

  meta = irmin.meta // {
    description = "Irmin backend which allow to store values into chunks";
  };

}

