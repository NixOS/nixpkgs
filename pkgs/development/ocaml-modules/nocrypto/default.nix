{ stdenv, fetchzip, ocaml, findlib, cstruct, type_conv, zarith, ounit }:

let
  version = "0.5.1";
  ocaml_version = stdenv.lib.getVersion ocaml;
in

assert stdenv.lib.versionAtLeast ocaml_version "4.01";

stdenv.mkDerivation {
  name = "ocaml-nocrypto-${version}";

  src = fetchzip {
    url = "https://github.com/mirleft/ocaml-nocrypto/archive/${version}.tar.gz";
    sha256 = "15gffvixk12ghsfra9amfszd473c8h188zfj03ngvblbdm0d80m0";
  };

  buildInputs = [ ocaml findlib type_conv ounit ];
  propagatedBuildInputs = [ cstruct zarith ];

  configureFlags = "--enable-tests";
  doCheck = true;
  checkTarget = "test";
  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirleft/ocaml-nocrypto;
    description = "Simplest possible crypto to support TLS";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
