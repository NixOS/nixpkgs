{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.2.4";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.2.4/xapian-core-1.2.4.tar.gz;
    sha256 = "0665c02aa1a6cccc071d4f2b426ac0feb6f4f8f0e50da720ce375ae6d3d6f348";
  };

  buildInputs = [zlib];

  meta = { 
    description = "Xapian Probabilistic Information Retrieval library";
    homepage = "http://xapian.org";
    license = "GPLv2";
  };
}
