{ stdenv, fetchzip, buildOcaml, time, autoconf, automake }:

buildOcaml rec {
  name = "bitstring";
  version = "f1673f8"; 
  src = fetchzip {
    url = https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/bitstring/source-archive.zip;
    sha256 = "03343yggwp3y483zj5axaalxlnl698xrjiv3hmd4c2s05g53iwas";
  };

  patches = [ ./camlp4-git.patch ./meta.patch ./srcdir.patch ];

  buildInputs = [time autoconf automake];
  doCheck = true;

  createFindlibDestdir = true;
  hasSharedObjects = true;

  preConfigure = "./bootstrap";

  meta = with stdenv.lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = http://code.google.com/p/bitstring/;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
