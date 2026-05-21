{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  numpy,
  camlzip,
}:

buildDunePackage (finalAttrs: {
  pname = "npy";
  version = "0.0.9";

  duneVersion = "3";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo = "npy-ocaml";
    rev = finalAttrs.version;
    hash = "sha256:1fryglkm20h6kdqjl55b7065b34bdg3g3p6j0jv33zvd1m5888m1";
  };

  propagatedBuildInputs = [ camlzip ];
  nativeCheckInputs = [ numpy ];

  doCheck = true;

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "OCaml implementation of the Npy format spec";
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.asl20;
  };
})
