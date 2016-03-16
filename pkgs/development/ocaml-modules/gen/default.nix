{ stdenv, fetchFromGitHub, ocaml, findlib, qtest, ounit }:

let version = "0.3"; in

stdenv.mkDerivation {
  name = "ocaml-gen-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = "${version}";
    sha256 = "0xrnkcfa5q86ammf49j5hynw5563x5sa2mk7vqf7g097j1szif72";
  };

  buildInputs = [ ocaml findlib qtest ounit ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/c-cube/gen;
    description = "Simple, efficient iterators for OCaml";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
