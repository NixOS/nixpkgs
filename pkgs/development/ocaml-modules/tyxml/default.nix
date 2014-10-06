{stdenv, fetchurl, ocaml, findlib, ocaml_oasis, camlp4}:

stdenv.mkDerivation {
  name = "tyxml-3.1.1";

  src = fetchurl {
    url = http://github.com/ocsigen/tyxml/archive/3.1.1.tar.gz;
    sha256 = "1r8im382r68kn8qy0857nv3y7h42i6ajyclxzmigfai7v2xdd05z";
    };

  buildInputs = [ocaml findlib ocaml_oasis camlp4];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://ocsigen.org/tyxml/;
    description = "A library that makes it almost impossible for your OCaml programs to generate wrong XML ouput, using static typing";
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [
      gal_bolle vbgl
      ];
  };

}
