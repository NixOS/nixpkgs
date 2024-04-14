{ lib, buildDunePackage, ppx_deriving, ppxlib, repr, alcotest, hex }:

buildDunePackage {
  pname = "ppx_repr";

  inherit (repr) src version;

  propagatedBuildInputs = [
    ppx_deriving
    ppxlib
    repr
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    hex
  ];

  meta = repr.meta // {
    description = "PPX deriver for type representations";
  };
}
