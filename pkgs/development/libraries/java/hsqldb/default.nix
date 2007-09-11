{ stdenv, fetchurl, unzip
}:

stdenv.mkDerivation {
  name = "hsqldb-1.8.0.7";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://sourceforge/hsqldb/hsqldb_1_8_0_7.zip;
    sha256 = "c35fe3c40fba7596e14c096cd0f3f8b70ac46610da7c5878a0ead6b454f5009c";
  };

  buildInputs = [ unzip
  ];
  
}
