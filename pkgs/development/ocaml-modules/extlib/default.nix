{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-extlib-1.5.2";

  src = fetchurl {
    url = http://ocaml-extlib.googlecode.com/files/extlib-1.5.3.tar.gz;
    sha256 = "c095eef4202a8614ff1474d4c08c50c32d6ca82d1015387785cf03d5913ec021";
  };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  buildPhase = ''
    make all
    make opt
  '';

  meta = {
    homepage = http://code.google.com/p/ocaml-extlib/;
    description = "Enhancements to the OCaml Standard Library modules";
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
  };
}
