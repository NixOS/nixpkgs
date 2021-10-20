{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, ounit }:

stdenv.mkDerivation rec {
  version = "0.5";
  pname = "ocaml${ocaml.version}-gen";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = version;
    sha256 = "14b8vg914nb0yp1hgxzm29bg692m0gqncjj43b599s98s1cwl92h";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = lib.optionals doCheck [ qtest ounit ];
  strictDeps = true;

  configureFlags = lib.optional doCheck "--enable-tests";

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/c-cube/gen";
    description = "Simple, efficient iterators for OCaml";
    license = lib.licenses.bsd3;
    inherit (ocaml.meta) platforms;
  };
}
