{ lib, buildDunePackage, fetchFromGitHub
, cohttp, dispatch, ptime
, ounit
}:

buildDunePackage rec {
  pname = "webmachine";
  version = "0.7.0";
  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-webmachine";
    rev = version;
    sha256 = "03ynb1l2jjqba88m9r8m5hwlm8izpfp617r4vcab5kmdim1l2ffx";
  };

  propagatedBuildInputs = [ cohttp dispatch ptime ];

  checkInputs = [ ounit ];

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    description = "A REST toolkit for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
