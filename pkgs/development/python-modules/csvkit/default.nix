{ stdenv, fetchPypi, buildPythonPackage,
  dateutil, dbf, xlrd, sqlalchemy, openpyxl,
 agate-excel, agate-dbf, agate-sql, isPy3k }:

buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "csvkit";
    version = "1.0.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "05vfsba9nwh4islszgs18rq8sjkpzqni0cdwvvkw7pi0r63pz2as";
    };

    propagatedBuildInputs = [ dateutil dbf xlrd sqlalchemy openpyxl
      agate-excel agate-dbf agate-sql ];

    doCheck = !isPy3k;
    # (only) python 3 we had 9 failures and 57 errors out of a much larger
    # number of tests.

    meta = with stdenv.lib; {
      description = "A library of utilities for working with CSV, the king of tabular file formats";
      maintainers = with maintainers; [ vrthra ];
      license = with licenses; [ mit ];
      homepage = https://github.com/wireservice/csvkit;
    };
}
