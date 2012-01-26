{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.2.8";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.2.8/xapian-core-1.2.8.tar.gz;
    sha256 = "00411ebac66a5592b87fc57ccfeb234c84b929ed23c185befb5df9929df3d4f9";
  };

  buildInputs = [ libuuid zlib ];

  meta = { 
    description = "Xapian Probabilistic Information Retrieval library";
    homepage = "http://xapian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
