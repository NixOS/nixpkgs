{ lib, buildDunePackage, irmin, irmin-test, astring, logs, lwt }:

buildDunePackage rec {

  pname = "irmin-fs";

  inherit (irmin) version src;

  propagatedBuildInputs = [ irmin astring logs lwt];

  useDune2 = true;

  checkInputs = lib.optional doCheck irmin-test;

  doCheck = true;

  meta = irmin.meta // {
    description = "Generic file-system backend for Irmin";
  };

}


