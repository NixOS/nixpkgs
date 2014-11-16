{stdenv, fetchurl, ocaml, findlib, ocaml_oasis, camlp4, uutf}:

stdenv.mkDerivation {
  name = "tyxml-3.3.0";

  src = fetchurl {
    url = http://github.com/ocsigen/tyxml/archive/3.3.0.tar.gz;
    sha256 = "0r1hj8qy91i48nd7wj0x2dqrgspqrry5awraxl4pl10vh0mn6pk7";
    };

  buildInputs = [ocaml findlib ocaml_oasis camlp4];

  propagatedBuildInputs = [uutf];

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
