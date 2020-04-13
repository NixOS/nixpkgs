{ lib, buildDunePackage, fetchFromGitHub
, cohttp, dispatch, ptime
, ounit
}:

buildDunePackage rec {
  pname = "webmachine";
  version = "0.6.1";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-webmachine";
    rev = "${version}";
    sha256 = "0kpbxsvjzylbxmxag77k1c8m8mwn4f4xscqk2i7fc591llgq9fp3";
  };

  propagatedBuildInputs = [ cohttp dispatch ptime ];

  checkInputs = lib.optional doCheck ounit;

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    description = "A REST toolkit for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
