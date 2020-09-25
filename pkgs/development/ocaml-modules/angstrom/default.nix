{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, result, bigstringaf }:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.14.1";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    sha256 = "1l69y0qspgi7kgrphyh7718hjb2sml1a9lljkp65bkqmmmi6ybly";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf result ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    homepage = "https://github.com/inhabitedtype/angstrom";
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
