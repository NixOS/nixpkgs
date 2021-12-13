{ lib, stdenv, fetchFromGitHub, ocaml, findlib }:

stdenv.mkDerivation rec {

  pname = "easy-format";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "easy-format";
    rev = "v${version}";
    sha256 = "sha256-qf73+T9a+eDy78iZgpA08TjIo+lvjftfSkwyT3M96gE=";
  };

  nativeBuildInputs = [ ocaml findlib ];
  strictDeps = true;

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "A high-level and functional interface to the Format module of the OCaml standard library";
    homepage = "https://github.com/ocaml-community/easy-format";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
