{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml-dolog";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = "dolog";
    rev = "v${version}";
    sha256 = "sha256-6wfqT5sqo4YA8XoHH3QhG6/TyzzXCzqjmnPuBArRoj8=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];

  strictDeps = true;

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/UnixJunkie/dolog";
    description = "Minimalistic lazy logger in OCaml";
    platforms = ocaml.meta.platforms or [ ];
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
