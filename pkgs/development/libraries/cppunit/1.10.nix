{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cppunit-1.10.0";
  
  src = fetchurl {
    url = mirror://sf/cppunit/cppunit-1.10.0.tar.gz;
    sha256 = "08w5ljd3rbz6wzipzxqx1ma779b6k930iwjrg4bckddigrq897bg";
  };

  patches = [./include-cstdlib.patch];
}
