{stdenv, fetchurl, buildOcaml, time}:

buildOcaml rec {
  name = "bitstring";
  version = "2.0.4"; 
  src = fetchurl {
    url = "http://bitstring.googlecode.com/files/ocaml-bitstring-${version}.tar.gz";
    sha256 = "0mapzn2ls5qcrzjm1az50lqjj76ldkmz4fbv2phc9w6smab50qy5";
  };

  patches = [ ./camlp4.patch ./meta.patch ./srcdir.patch ];

  buildInputs = [time];
  doCheck = true;

  createFindlibDestdir = true;
  hasSharedObjects = true;

  meta = with stdenv.lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = http://code.google.com/p/bitstring/;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
