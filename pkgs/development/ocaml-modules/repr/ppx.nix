{
  lib,
  buildDunePackage,
  fetchpatch,
  ppx_deriving,
  ppxlib,
  repr,
  alcotest,
  hex,
}:

buildDunePackage {
  pname = "ppx_repr";

  inherit (repr) src version;

  patches = lib.optionals (lib.versionAtLeast ppxlib.version "0.36") [
    (fetchpatch {
      url = "https://github.com/mirage/repr/commit/460fc85a2804e3301bfc0e79413f5df472d95374.patch";
      hash = "sha256-8nEPyeZ1s9Q/6+BKtdMb9kVhTfCdMmRrU3xpvizVZHA=";
    })
    (fetchpatch {
      url = "https://github.com/mirage/repr/commit/c939a7317e126589bd6d6bd1d9e38cff749bcdb1.patch";
      hash = "sha256-Srf5fZoc0iiJEZiW8PnIM5VdHOGofbdkhfnjQvFcTq0=";
    })
  ];

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
