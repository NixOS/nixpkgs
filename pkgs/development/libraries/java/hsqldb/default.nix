{ stdenv, fetchurl, unzip
}:

stdenv.mkDerivation {
  name = "hsqldb-1.8.0.9";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://sourceforge/hsqldb/hsqldb_1_8_0_9.zip;
    sha256 = "e98d1d8bca15059f4ef4f0d3dde2d75778a5e1bbe8bc12abd4ec2cac39d5adec";
  };

  buildInputs = [ unzip
  ];
  
  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
