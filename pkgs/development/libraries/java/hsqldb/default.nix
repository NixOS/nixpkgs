{ stdenv, fetchurl, unzip
}:

stdenv.mkDerivation {
  name = "hsqldb-2.4.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://sourceforge/hsqldb/hsqldb_1_8_0_9.zip;
    sha256 = "1v5dslwsqb7csjmi5g78pghsay2pszidvlzhyi79y18mra5iv3g9";
  };

  buildInputs = [ unzip
  ];

  meta = with stdenv.lib; {
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
