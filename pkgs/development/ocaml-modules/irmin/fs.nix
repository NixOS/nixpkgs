{
  buildDunePackage,
  irmin,
  astring,
  logs,
  lwt,
  alcotest,
  irmin-test,
  irmin-watcher,
}:

buildDunePackage {

  pname = "irmin-fs";

  inherit (irmin) version src;

  propagatedBuildInputs = [
    irmin
    astring
    logs
    lwt
  ];

  checkInputs = [
    alcotest
    irmin-test
    irmin-watcher
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Generic file-system backend for Irmin";
  };

}
