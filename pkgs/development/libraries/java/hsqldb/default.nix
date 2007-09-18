{ stdenv, fetchurl, unzip
}:

stdenv.mkDerivation {
  name = "hsqldb-1.8.0.8";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://sourceforge/hsqldb/hsqldb_1_8_0_8.zip;
    sha256 = "1428pkizd19i2p7iiha0nkgypa3hznj4vbw503ayyhnnhbgw4ama";
  };

  buildInputs = [ unzip
  ];
  
}
