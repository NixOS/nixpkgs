{
  buildDunePackage,
  irmin,
  irmin-test,
  fmt,
  logs,
  lwt,
  alcotest,
}:

buildDunePackage {

  pname = "irmin-chunk";
  inherit (irmin) version src;

  propagatedBuildInputs = [
    irmin
    fmt
    logs
    lwt
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    irmin-test
  ];

  meta = irmin.meta // {
    description = "Irmin backend which allow to store values into chunks";
  };

}
