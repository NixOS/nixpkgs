{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-re-1.4.0";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${name}.tar.gz";
    sha256 = "1xcfmhjgd7prqx2g1addlrk84xpfafmqnpjkqrvg7mw0hn1p7v2m";
  };

  buildInputs = [ ocaml findlib ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    platforms = ocaml.meta.platforms;
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
