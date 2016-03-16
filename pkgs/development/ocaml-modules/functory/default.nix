{stdenv, fetchurl, ocaml, findlib}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.11";

stdenv.mkDerivation {

  name = "ocaml-functory-0.5";

  src = fetchurl {
    url = https://www.lri.fr/~filliatr/functory/download/functory-0.5.tar.gz;
    sha256 = "1j17rhifdjv1z262dma148ywg34x0zjn8vczdrnkwajsm4qg1hw3";
  };

  buildInputs = [ ocaml findlib ];

  installTargets = "ocamlfind-install";

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://www.lri.fr/~filliatr/functory/;
    description = "A distributed computing library for Objective Caml which facilitates distributed execution of parallelizable computations in a seamless fashion";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
