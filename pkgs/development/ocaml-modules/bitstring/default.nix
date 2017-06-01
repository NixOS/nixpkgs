{ stdenv, fetchurl, buildOcaml, time, autoconf, automake }:

buildOcaml rec {
  name = "bitstring";
  version = "2.1.0";
  src = fetchurl {
    url = http://github.com/xguerin/bitstring/archive/v2.1.0.tar.gz;
    sha256 = "0miw4banfpmx4kxrckpqr57b1fcmsqdmspyjx6gqjd4kghm4l7xj";
  };

  patches = [ ./camlp4-git.patch ./srcdir.patch ];

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
