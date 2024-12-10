{
  lib,
  buildDunePackage,
  index,
  ppx_irmin,
  irmin,
  optint,
  fmt,
  logs,
  lwt,
  mtime,
  cmdliner,
  checkseum,
  rusage,
  alcotest,
  alcotest-lwt,
  astring,
  irmin-test,
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.12";

  pname = "irmin-pack";

  inherit (irmin) version src;

  nativeBuildInputs = [ ppx_irmin ];

  propagatedBuildInputs = [
    index
    irmin
    optint
    fmt
    logs
    lwt
    mtime
    cmdliner
    checkseum
    rusage
  ];

  checkInputs = [
    astring
    alcotest
    alcotest-lwt
    irmin-test
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Irmin backend which stores values in a pack file";
    mainProgram = "irmin_fsck";
  };

}
