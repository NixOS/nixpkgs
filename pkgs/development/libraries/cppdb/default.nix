{ stdenv, fetchurl, cmake, sqlite, libmysql, postgresql, unixODBC }:

stdenv.mkDerivation rec {
  name = "cppdb";
  version = "0.3.1";

  src = fetchurl {
      url = "mirror://sourceforge/cppcms/${name}-${version}.tar.bz2";
      sha256 = "0blr1casmxickic84dxzfmn3lm7wrsl4aa2abvpq93rdfddfy3nn";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake sqlite libmysql postgresql unixODBC ];

  cmakeFlags = [ "--no-warn-unused-cli" ];

  meta = with stdenv.lib; {
    homepage = "http://cppcms.com/sql/cppdb/";
    description = "C++ Connectivity library that supports MySQL, PostgreSQL, Sqlite3 databases and generic ODBC drivers";
    platforms = platforms.linux ;
    license = licenses.boost;
    maintainers = [ maintainers.juliendehos ];
  };
}

