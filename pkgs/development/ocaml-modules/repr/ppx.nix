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

  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://github.com/mirage/repr/commit/9dcaeaa7e5f45998f76e1eab68f8fd18edc980cc.patch";
    hash = "sha256-MKuZ4f8m/nNlgZpomGgqr80s5btynKcb1b4khpIIOY4=";
  });

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
