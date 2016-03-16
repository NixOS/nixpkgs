{ stdenv, fetchzip, ocaml, findlib, cstruct }:

let version = "1.0.0"; in

stdenv.mkDerivation {
  name = "ocaml-hex-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-hex/archive/${version}.tar.gz";
    sha256 = "0g4cq4bsksga15fa5ln083gkglawknbnhi2s4k8yk0yi5xngvwm4";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ cstruct ];
  configureFlags = "--enable-tests";
  doCheck = true;
  checkTarget = "test";
  createFindlibDestdir = true;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = https://github.com/mirage/ocaml-hex;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
