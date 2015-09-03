{stdenv, fetchgit, buildOcaml, time, autoconf, automake}:

buildOcaml rec {
  name = "bitstring";
  version = "f1673f8"; 
  src = fetchgit {
    url = "https://code.google.com/p/bitstring/";
    rev = "f1673f8";
    sha256 = "1lh97qf1b7mq64pxkphr2w91ri5hfwg58cpjb2xd8a453c9jylw4";
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
