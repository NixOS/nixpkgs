{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, result, bigstringaf, ppx_let }:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.15.0";

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    sha256 = "1hmrkdcdlkwy7rxhngf3cv3sa61cznnd9p5lmqhx20664gx2ibrh";
  };

  checkInputs = [ alcotest ppx_let ];
  propagatedBuildInputs = [ bigstringaf result ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    homepage = "https://github.com/inhabitedtype/angstrom";
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
