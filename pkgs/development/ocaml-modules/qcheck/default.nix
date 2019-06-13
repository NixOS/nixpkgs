{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, ounit }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-qcheck-0.7";
  src = fetchzip {
    url = https://github.com/c-cube/qcheck/archive/0.7.tar.gz;
    sha256 = "1afy7li74r3ivpvq670gvsj1rmglh5rnvb17p6w8gy5rh30aljah";
  };

  buildInputs = [ ocaml findlib ocamlbuild ounit ];

  configureFlags = [ "--enable-tests" ];

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
