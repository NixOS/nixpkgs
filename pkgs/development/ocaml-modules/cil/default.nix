{ stdenv, fetchurl, perl, ocaml, findlib }:
stdenv.mkDerivation {
  name = "ocaml-cil-1.7.3";
  src = fetchurl {
    url = mirror://sourceforge/cil/cil-1.7.3.tar.gz;
    sha256 = "05739da0b0msx6kmdavr3y2bwi92jbh3szc35d7d8pdisa8g5dv9";
  };

  buildInputs = [ perl ocaml findlib ];

  createFindlibDestdir = true;

  preConfigure = ''
    export FORCE_PERL_PREFIX=1
  '';
  prefixKey = "-prefix=";

  meta = with stdenv.lib; {
    homepage = http://kerneis.github.io/cil/;
    description = "A front-end for the C programming language that facilitates program analysis and transformation";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
