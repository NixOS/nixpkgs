{ stdenv, fetchzip, ocaml, findlib, ounit }:

stdenv.mkDerivation rec {
  name = "ocaml-re-1.5.0";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${name}.tar.gz";
    sha256 = "17avk7kwmgdjkri1sj5q4a59ykc9rj0bxj6ixxpl6i0n49br3f92";
  };

  buildInputs = [ ocaml findlib ounit ];

  configurePhase = "ocaml setup.ml -configure --prefix $out --enable-tests";
  buildPhase = "ocaml setup.ml -build";
  doCheck = true;
  checkPhase = "ocaml setup.ml -test";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    platforms = ocaml.meta.platforms or [];
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
