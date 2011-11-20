{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.2.7";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.2.7/xapian-core-1.2.7.tar.gz;
    sha256 = "6ce8cb3502f35245ec0cb0dcf579ce4f65c015a2f2e8d1b4c388c95f58278c89";
  };

  buildInputs = [ libuuid zlib ];

  meta = { 
    description = "Xapian Probabilistic Information Retrieval library";
    homepage = "http://xapian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
