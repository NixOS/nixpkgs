{ lib, stdenv, mkCoqDerivation, coq, trakt, cvc4, veriT, version ? null }:
with lib;

mkCoqDerivation {
  pname = "smtcoq";
  owner = "smtcoq";

  release."itp22".rev    = "1d60d37558d85a4bfd794220ec48849982bdc979";
  release."itp22".sha256 = "sha256-CdPfgDfeJy8Q6ZlQeVCSR/x8ZlJ2kSEF6F5UnAespnQ=";

  inherit version;
  defaultVersion = with versions; switch coq.version [
    { case = isEq "8.13"; out = "itp22"; }
  ] null;

  propagatedBuildInputs = [ trakt cvc4 ]
    ++ lib.optionals (!stdenv.isDarwin) [ veriT ]
    ++ (with coq.ocamlPackages; [ num zarith ]);
  mlPlugin = true;
  nativeBuildInputs = with coq.ocamlPackages; [ ocamlbuild ];

  meta = {
    description = "Communication between Coq and SAT/SMT solvers ";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
