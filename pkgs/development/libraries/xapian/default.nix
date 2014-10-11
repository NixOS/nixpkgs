{ stdenv, fetchurl, libuuid, zlib }:

stdenv.mkDerivation {
  name = "xapian-1.3.1";

  src = fetchurl {
    url = http://oligarchy.co.uk/xapian/1.3.1/xapian-core-1.3.1.tar.gz;
    sha256 = "03z31z0xpj9a4aryr5hcq3y8wwv8qc1dn487ahzkfgir7rv0zvk4";
  };

  buildInputs = [ libuuid zlib ];

  configureFlags = [ "--program-suffix=" ];

  meta = { 
    description = "Search engine library";
    homepage = "http://xapian.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
