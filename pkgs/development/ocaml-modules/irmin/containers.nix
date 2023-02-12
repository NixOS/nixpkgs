{ buildDunePackage
, irmin, irmin-fs, ppx_irmin, lwt, mtime
, alcotest, alcotest-lwt, cacert
}:

buildDunePackage {
  pname = "irmin-containers";

  inherit (ppx_irmin) src version strictDeps;
  duneVersion = "3";

  nativeBuildInputs = [
    ppx_irmin
  ];

  propagatedBuildInputs = [
    irmin
    irmin-fs
    ppx_irmin
    lwt
    mtime
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    alcotest-lwt
    cacert
  ];

  meta = ppx_irmin.meta // {
    description = "Mergeable Irmin data structures";
  };
}
