{ lib, buildDunePackage, fetchFromGitHub, numpy, camlzip }:

buildDunePackage rec {
  pname = "npy";
  version = "0.0.9";

  duneVersion = "3";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "${pname}-ocaml";
    rev    = version;
    hash = "sha256:1fryglkm20h6kdqjl55b7065b34bdg3g3p6j0jv33zvd1m5888m1";
  };

  propagatedBuildInputs = [ camlzip ];
  nativeCheckInputs = [ numpy ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "OCaml implementation of the Npy format spec";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
  };
}
