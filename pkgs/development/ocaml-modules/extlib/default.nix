{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-extlib-1.5.2";

  src = fetchurl {
    url = "http://ocaml-extlib.googlecode.com/files/extlib-1.5.2.tar.gz";
    sha256 = "ca6d69adeba4242ce41c02a23746ba1e464c0bbec66e2d16b02c3c6e85dc10aa";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make opt
  '';

  meta = {
    homepage = "http://code.google.com/p/ocaml-extlib/";
    description = "Enhancements to the OCaml Standard Library modules";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
  };
}
