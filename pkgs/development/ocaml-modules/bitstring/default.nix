{ stdenv, fetchurl, buildOcaml, time, autoconf, automake }:

buildOcaml rec {
  name = "bitstring";
  version = "2.1.1";
  src = fetchurl {
    url = http://github.com/xguerin/bitstring/archive/v2.1.1.tar.gz;
    sha256 = "0vy8ibrxccii1jbsk5q6yh1kxjigqvi7lhhcmizvd5gfhf7mfyc8";
  };

  patches = [ ./camlp4-git.patch ./srcdir.patch ];

  buildInputs = [time autoconf automake];
  doCheck = true;

  createFindlibDestdir = true;
  hasSharedObjects = true;

  preConfigure = "./bootstrap";

  meta = with stdenv.lib; {
    description = "This library adds Erlang-style bitstrings and matching over bitstrings as a syntax extension and library for OCaml";
    homepage = https://github.com/xguerin/bitstring;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.maurer ];
  };
}
