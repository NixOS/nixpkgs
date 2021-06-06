{ buildDunePackage, repr, ppxlib, ppx_deriving, alcotest, hex }:

buildDunePackage {
  pname = "ppx_repr";

  inherit (repr) src version useDune2;

  propagatedBuildInputs = [
    repr
    ppxlib
    ppx_deriving
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
