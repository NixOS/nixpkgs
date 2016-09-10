{stdenv, fetchurl, which, ocaml, dyntype, ezjsonm, findlib, omd, ounit, re, type_conv, ulex, uri, xmlm}:

stdenv.mkDerivation {
  name = "ocaml-cow-1.0.0";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cow/archive/v1.0.0/ocaml-cow-1.0.0.tar.gz";
    sha256 = "0svcbn209i76mc4cpm7s881l3kl2z3jkak453vwdy50pvsg51y03";
  };

  buildInputs = [ which ocaml findlib ounit type_conv xmlm ];

  propagatedBuildInputs = [ dyntype ezjsonm omd re ulex uri ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export DESTDIR=$OCAMLFIND_DESTDIR
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/ocaml-cow;
    description = "XML, JSON, HTML, CSS, and Markdown syntax and libraries";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
