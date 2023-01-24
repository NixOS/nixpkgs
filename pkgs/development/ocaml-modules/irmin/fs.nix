{ lib, buildDunePackage, irmin, astring, logs, lwt
, alcotest, irmin-test, irmin-watcher }:

buildDunePackage rec {

  pname = "irmin-fs";

  inherit (irmin) version src strictDeps;

  propagatedBuildInputs = [ irmin astring logs lwt ];

  nativeCheckInputs = [ alcotest irmin-test irmin-watcher ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Generic file-system backend for Irmin";
  };

}
