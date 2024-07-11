{ buildDunePackage, qcheck-core
, qcheck, ppxlib, ppx_deriving }:

buildDunePackage {
  pname = "ppx_deriving_qcheck";

  inherit (qcheck-core) version src patches;

  duneVersion = "3";

  propagatedBuildInputs = [
    qcheck
    ppxlib
    ppx_deriving
  ];

  meta = qcheck-core.meta // {
    description = "PPX Deriver for QCheck";
  };
}
