{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, result, bigstringaf }:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.12.1";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    sha256 = "0w0wavqzdy2hrh7cjyl9w72ad4vndhwhknwvyacvkwkja5wys5b2";
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
