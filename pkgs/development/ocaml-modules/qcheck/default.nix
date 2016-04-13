{ stdenv, fetchzip, ocaml, findlib, oasis, ounit }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

stdenv.mkDerivation {

  name = "ocaml-qcheck-0.4.0.1";
  src = fetchzip {
    url = https://github.com/c-cube/qcheck/archive/0.4.0.1.tar.gz;
    sha256 = "0j2jdrfz8rrslgjihnfgg8yy12860z2vvf7hqzjbmfmf03hz4pgv";
  };

  buildInputs = [ ocaml findlib oasis ounit ];

  configureFlags = "--enable-tests --enable-ounit";

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
