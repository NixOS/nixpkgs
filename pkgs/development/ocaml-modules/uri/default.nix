{ stdenv, fetchgit, ocaml, findlib, re, sexplib, stringext }:

let version = "1.7.2"; in

stdenv.mkDerivation {
  name = "ocaml-uri-${version}";

  src = fetchgit {
    url = https://github.com/mirage/ocaml-uri.git;
    rev = "refs/tags/v${version}";
    sha256 = "19rq68dzvqzpqc2zvrk5sj1iklknnyrlbcps2vb8iw4cjlrnnaa1";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ re sexplib stringext ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = ''
    ocaml setup.ml -build
    ocaml setup.ml -doc
  '';
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirage/ocaml-uri;
    platforms = ocaml.meta.platforms;
    description = "RFC3986 URI parsing library for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
