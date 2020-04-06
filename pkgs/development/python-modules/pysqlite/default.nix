{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  pname = "pysqlite";
  version = "2.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17d3335863e8cf8392eea71add33dab3f96d060666fe68ab7382469d307f4490";
  };

  # Need to use the builtin sqlite3 on Python 3
  disabled = isPy3k;

  # Since the `.egg' file is zipped, the `NEEDED' of the `.so' files
  # it contains is not taken into account.  Thus, we must explicitly make
  # it a propagated input.
  propagatedBuildInputs = [ pkgs.sqlite ];

  patchPhase = ''
    substituteInPlace "setup.cfg"                                     \
            --replace "/usr/local/include" "${pkgs.sqlite.dev}/include"   \
            --replace "/usr/local/lib" "${pkgs.sqlite.out}/lib"
    ${stdenv.lib.optionalString (!stdenv.isDarwin) ''export LDSHARED="$CC -pthread -shared"''}
  '';

  meta = with stdenv.lib; {
    homepage = https://pysqlite.org/;
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
    license = licenses.bsd3;
  };

}
