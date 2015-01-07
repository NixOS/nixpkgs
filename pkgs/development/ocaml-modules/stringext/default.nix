{ stdenv, fetchgit, ocaml, findlib }:

let version = "1.2.0"; in

stdenv.mkDerivation {
  name = "ocaml-stringext-${version}";

  src = fetchgit {
    url = https://github.com/rgrinberg/stringext.git;
    rev = "refs/tags/v${version}";
    sha256 = "04ixh33225n2fyc0i35pk7h9shxfdg9grhvkxy086zppki3a3vc6";
  };

  buildInputs = [ ocaml findlib ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/rgrinberg/stringext;
    platforms = ocaml.meta.platforms;
    description = "Extra string functions for OCaml";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
