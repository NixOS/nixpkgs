{ stdenv, fetchzip, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-re-1.3.1";

  src = fetchzip {
    url = "https://github.com/ocaml/ocaml-re/archive/${name}.tar.gz";
    sha256 = "11d4k43pc97kvdbjgjcxpc0gq6yal4galkxlrfdp1iypwdcni92g";
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
