{ lib, buildDunePackage, ppx_deriving, ppxlib, repr, alcotest, hex }:

buildDunePackage {
  pname = "ppx_repr";

  inherit (repr) src version strictDeps;
  duneVersion = "3";

  propagatedBuildInputs = [
    ppx_deriving
    ppxlib
    repr
  ];

  doCheck = false; # tests fail with ppxlib >= 0.23.0
  checkInputs = [
    alcotest
    hex
  ];

  meta = repr.meta // {
    description = "PPX deriver for type representations";
  };
}
