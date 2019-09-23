{ stdenv, fetchurl, cxxtools, postgresql, mysql, sqlite, zlib, openssl }:

stdenv.mkDerivation rec {
  pname = "tntdb";
  version = "1.3";

  src = fetchurl {
    url = "http://www.tntnet.org/download/${pname}-${version}.tar.gz";
    sha256 = "0js79dbvkic30bzw1pf26m64vs2ssw2sbj55w1dc0sy69dlv4fh9";
  };

  buildInputs = [ cxxtools postgresql mysql.connector-c sqlite zlib openssl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.tntnet.org/tntdb.html;
    description = "C++ library which makes accessing SQL databases easy and robust";
    platforms = platforms.linux ;
    license = licenses.lgpl21;
    maintainers = [ maintainers.juliendehos ];
  };
}
