{ stdenv, fetchFromGitHub, buildDunePackage, alcotest, result, bigstringaf }:

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

  buildInputs = [ alcotest ];
  propagatedBuildInputs = [ bigstringaf result ];
  doCheck = true;

  meta = {
    homepage = https://github.com/inhabitedtype/angstrom;
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
