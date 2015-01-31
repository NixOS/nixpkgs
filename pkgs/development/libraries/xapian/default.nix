{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.2.19";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.2.19/xapian-core-1.2.19.tar.xz;
    sha256 = "11a7lm3w3pchk4rx144nc2p31994spyqmldm18ph86zzi01jcy2a";
  };

  buildInputs = [ libuuid zlib ];

  meta = { 
    description = "Search engine library";
    homepage = "http://xapian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
