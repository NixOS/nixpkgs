{ lib, buildDunePackage, fetchFromGitHub
, cohttp, dispatch, ptime
, ounit
}:

buildDunePackage rec {
  pname = "webmachine";
  version = "0.6.2";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "ocaml-webmachine";
    rev = "${version}";
    sha256 = "1zi1vsm589y2njwzsqkmdbxvs9s4xlgbd62xqw2scp60mccp09nk";
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
