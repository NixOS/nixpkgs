{ stdenv, fetchurl, ocaml, findlib, ocaml_oasis, camlp4, uutf }:

stdenv.mkDerivation {
  name = "tyxml-3.4.0";

  src = fetchurl {
    url = http://github.com/ocsigen/tyxml/archive/3.4.0.tar.gz;
    sha256 = "10hb0b2j33fjqzmx450ns7dmf4pqmx3gyvr6dk99mghqk13cj5ww";
    };

  buildInputs = [ocaml findlib ocaml_oasis camlp4];

  propagatedBuildInputs = [uutf];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/tyxml/;
    description = "A library that makes it almost impossible for your OCaml programs to generate wrong XML output, using static typing";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      gal_bolle vbgl
      ];
  };

}
