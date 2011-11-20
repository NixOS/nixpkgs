{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.2.5";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.2.5/xapian-core-1.2.5.tar.gz;
    sha256 = "392ccfccb4372725be24509e5ee95a7422f07c3d47d0cbdbb8545e789cc936f7";
  };

  buildInputs = [ libuuid zlib ];

  meta = { 
    description = "Xapian Probabilistic Information Retrieval library";
    homepage = "http://xapian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
