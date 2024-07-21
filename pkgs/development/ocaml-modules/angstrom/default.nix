{ lib, fetchFromGitHub, buildDunePackage, ocaml, ocaml-syntax-shims, alcotest, bigstringaf, ppx_let, gitUpdater }:

buildDunePackage rec {
  pname = "angstrom";
  version = "0.16.0";

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = pname;
    rev    = version;
    hash = "sha256-vilGto5ciyKzVJd72z4B+AvM1nf3x3O7DHXrK5SIajQ=";
  };

  checkInputs = [ alcotest ppx_let ];
  buildInputs = [ ocaml-syntax-shims ];
  propagatedBuildInputs = [ bigstringaf ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/inhabitedtype/angstrom";
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
