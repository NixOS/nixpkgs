{ stdenv, fetchurl, ocaml, findlib }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.11";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then {
    version = "0.6";
    sha256 = "18wpyxblz9jh5bfp0hpffnd0q8cq1b0dqp0f36vhqydfknlnpx8y";
  } else {
    version = "0.5";
    sha256 = "1j17rhifdjv1z262dma148ywg34x0zjn8vczdrnkwajsm4qg1hw3";
  };
in

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-functory-${param.version}";

  src = fetchurl {
    url = "https://www.lri.fr/~filliatr/functory/download/functory-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ];

  installTargets = [ "ocamlfind-install" ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://www.lri.fr/~filliatr/functory/;
    description = "A distributed computing library for Objective Caml which facilitates distributed execution of parallelizable computations in a seamless fashion";
    license = licenses.lgpl21;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
