{ lib, fetchFromGitHub, buildDunePackage, ocaml, ocaml-syntax-shims, alcotest, result, bigstringaf, ppx_let, gitUpdater }:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.15.0";
  useDune2 = true;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    sha256 = "1hmrkdcdlkwy7rxhngf3cv3sa61cznnd9p5lmqhx20664gx2ibrh";
  };

  checkInputs = [ alcotest ppx_let ];
  buildInputs = [ ocaml-syntax-shims ];
  propagatedBuildInputs = [ bigstringaf result ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/inhabitedtype/angstrom";
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
