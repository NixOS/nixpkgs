{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ounit }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-qcheck-0.6";
  src = fetchzip {
    url = https://github.com/c-cube/qcheck/archive/0.6.tar.gz;
    sha256 = "14rlg0jh4p12sd9xagppacsbfw0239anbq5r1aqhsqxlfmzbmi1p";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit ];

  configureFlags = "--enable-tests";

  doCheck = true;
  checkPhase = "ocaml setup.ml -test";

  createFindlibDestdir = true;

  meta = {
    description = "QuickCheck inspired property-based testing for OCaml";
    homepage = https://github.com/c-cube/qcheck/;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
