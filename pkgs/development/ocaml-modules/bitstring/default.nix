{stdenv, fetchurl, ocaml, findlib, camlp4, time}:

let
  version = "2.0.4";
in 
 
stdenv.mkDerivation {
  name = "ocaml-bitstring-${version}"; 
  src = fetchurl {
    url = "http://bitstring.googlecode.com/files/ocaml-bitstring-${version}.tar.gz";
    sha256 = "0mapzn2ls5qcrzjm1az50lqjj76ldkmz4fbv2phc9w6smab50qy5";
  };

  buildInputs = [ocaml findlib camlp4 time];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "The ocaml-bitstring project adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml.";
    homepage = http://code.google.com/p/bitstring/;
    license = licenses.lgpl21;
    platforms = ocaml.meta.platforms;
  };
}
