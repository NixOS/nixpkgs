{stdenv, fetchurl, ocaml, findlib, menhir, yojson, ulex, pprint, fix, functory}:

stdenv.mkDerivation {

  name = "mezzo-0.0.m8";

  src = fetchurl {
    url = https://github.com/protz/mezzo/archive/m8.tar.gz;
    sha256 = "17mfapgqp8ssa5x9blv72zg9l561zbiwv3ikwi6nl9dd36lwkkc6";
  };

  buildInputs = [ ocaml findlib yojson menhir ulex pprint fix functory ];

  createFindlibDestdir = true;

  postInstall = ''
    mkdir $out/bin
    cp mezzo $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://protz.github.io/mezzo/;
    description = "A programming language in the ML tradition, which places strong emphasis on the control of aliasing and access to mutable memory";
    license = licenses.gpl2;
    platforms = ocaml.meta.platforms;
  };
}


