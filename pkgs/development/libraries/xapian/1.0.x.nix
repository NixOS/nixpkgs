{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.0.23";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.0.23/xapian-core-1.0.23.tar.gz;
    sha256 = "0aed7296bd56b4b49aba944cc744e1e76fff8cfb0a70fd5b1f49d4c62a97ecc6";
  };

  buildInputs = [ zlib ];

  meta = { 
    description = "Xapian Probabilistic Information Retrieval library";
    homepage = "http://xapian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
