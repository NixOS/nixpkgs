{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, ounit }:

let version = "0.5"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-gen-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = version;
    sha256 = "14b8vg914nb0yp1hgxzm29bg692m0gqncjj43b599s98s1cwl92h";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ qtest ounit ];
  strictDeps = true;

  configureFlags = [
    "--enable-tests"
  ];

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/c-cube/gen";
    description = "Simple, efficient iterators for OCaml";
    license = lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
