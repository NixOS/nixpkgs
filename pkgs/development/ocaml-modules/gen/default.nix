{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, ounit }:

let version = "0.4"; in

stdenv.mkDerivation {
  name = "ocaml-gen-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = "${version}";
    sha256 = "041dga300fh1y6fi8y0fkri2qda406lf2dmbrgllazw3rp07zkzj";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ounit ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/c-cube/gen;
    description = "Simple, efficient iterators for OCaml";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
