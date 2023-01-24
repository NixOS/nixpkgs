{ lib, buildDunePackage
, index, ppx_irmin, irmin, optint, fmt, logs, lwt, mtime, cmdliner
, alcotest, alcotest-lwt, astring, irmin-test
}:

buildDunePackage rec {
  minimalOCamlVersion = "4.08";

  pname = "irmin-pack";

  inherit (irmin) version src strictDeps;

  nativeBuildInputs = [ ppx_irmin ];

  propagatedBuildInputs = [ index irmin optint fmt logs lwt mtime cmdliner ];

  nativeCheckInputs = [ astring alcotest alcotest-lwt irmin-test ];

  doCheck = true;

  meta = irmin.meta // {
    description = "Irmin backend which stores values in a pack file";
    mainProgram = "irmin_fsck";
  };

}
