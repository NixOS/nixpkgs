{ buildDunePackage
, irmin, irmin-fs, ppx_irmin, lwt, mtime
, alcotest, alcotest-lwt, cacert
}:

buildDunePackage {
  pname = "irmin-containers";

  inherit (ppx_irmin) src version strictDeps;

  nativeBuildInputs = [
    ppx_irmin
  ];

  propagatedBuildInputs = [
    irmin irmin-fs ppx_irmin lwt mtime
  ];

  doCheck = true;
  nativeCheckInputs = [
    alcotest alcotest-lwt cacert
  ];

  meta = ppx_irmin.meta // {
    description = "Mergeable Irmin data structures";
  };
}
