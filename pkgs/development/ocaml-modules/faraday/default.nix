{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, bigstringaf }:

buildDunePackage rec {
  pname = "faraday";
  version = "0.8.1";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "sha256-eeR+nst/r2iFxCDmRS+LGr3yl/o27DcsS30YAu1GJmc=";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    description = "Serialization library built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
