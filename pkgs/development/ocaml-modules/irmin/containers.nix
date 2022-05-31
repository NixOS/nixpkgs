{ buildDunePackage
, irmin, irmin-unix, irmin-git, ppx_irmin, lwt, mtime
, alcotest, alcotest-lwt, cacert
}:

buildDunePackage rec {
  pname = "irmin-containers";

  inherit (ppx_irmin) src version strictDeps;

  nativeBuildInputs = [
    ppx_irmin
  ];

  propagatedBuildInputs = [
    irmin irmin-unix irmin-git ppx_irmin lwt mtime
  ];


  buildInputs = checkInputs; # dune builds tests at build-time

  doCheck = true;
  checkInputs = [
    alcotest alcotest-lwt cacert
  ];

  meta = ppx_irmin.meta // {
    description = "Mergeable Irmin data structures";
  };
}
