{stdenv, fetchurl, python, sqlite}:

stdenv.mkDerivation rec {
  name = "pysqlite-2.5.5";

  src = fetchurl {
    url = "http://oss.itsystementwicklung.de/download/pysqlite/2.5/2.5.5/${name}.tar.gz";
    sha256 = "0kylyjzxc4kd0z3xsvs0i63163kphfh0xcc4f0d0wyck93safz7g";
  };

  builder = ./builder.sh;

  buildInputs = [ python sqlite ];

  inherit stdenv sqlite;

  meta = {
    homepage = http://pysqlite.org/;

    description = "Python bindings for the SQLite embedded relational database engine";

    longDescription = ''
      pysqlite is a DB-API 2.0-compliant database interface for SQLite.

      SQLite is a relational database management system contained in
      a relatively small C library.  It is a public domain project
      created by D. Richard Hipp.  Unlike the usual client-server
      paradigm, the SQLite engine is not a standalone process with
      which the program communicates, but is linked in and thus
      becomes an integral part of the program.  The library
      implements most of SQL-92 standard, including transactions,
      triggers and most of complex queries.

      pysqlite makes this powerful embedded SQL engine available to
      Python programmers.  It stays compatible with the Python
      database API specification 2.0 as much as possible, but also
      exposes most of SQLite's native API, so that it is for example
      possible to create user-defined SQL functions and aggregates
      in Python.
    '';

    license = "revised BSD";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
