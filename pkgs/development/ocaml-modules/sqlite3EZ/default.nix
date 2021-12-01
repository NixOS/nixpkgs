{ lib, stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, twt, ocaml_sqlite3 }:

assert lib.versionAtLeast (lib.getVersion ocaml) "3.12";

if lib.versionAtLeast ocaml.version "4.06"
then throw "sqlite3EZ is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml-sqlite3EZ";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mlin";
    repo = "ocaml-sqlite3EZ";
    rev = "v${version}";
    sha256 = "sha256-pKysvth0efxJeyJQY2Dnqarg7OtsKyyLnFV/1ZhsfDY=";
  };

  buildInputs = [ ocaml findlib ocamlbuild twt ];

  propagatedBuildInputs = [ ocaml_sqlite3 ];

  createFindlibDestdir = true;

  meta = with lib; {
    homepage = "https://github.com/mlin/ocaml-sqlite3EZ";
    description = "A thin wrapper for sqlite3-ocaml with a simplified interface";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [ ];
  };
}
