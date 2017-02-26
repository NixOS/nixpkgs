{ stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-mparser-1.2.1";
  src = fetchzip {
    url = http://github.com/cakeplus/mparser/archive/1.2.1.tar.gz;
    sha256 = "1g1r3p0inmm5xwh9i5mrc4s414b0j8l13a66hpvwhqcpp6qglfh3";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = "ocaml setup.ml -configure";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    description = "A simple monadic parser combinator OCaml library";
    license = stdenv.lib.licenses.lgpl21Plus;
    homepage = https://github.com/cakeplus/mparser;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
