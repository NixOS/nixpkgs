{ lib, fetchPypi, buildPythonPackage, isPy3k
, agate, agate-excel, agate-dbf, agate-sql, six
, argparse, ordereddict, simplejson
, glibcLocales, nose, mock, unittest2
}:

buildPythonPackage rec {
  pname = "csvkit";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05vfsba9nwh4islszgs18rq8sjkpzqni0cdwvvkw7pi0r63pz2as";
  };

  propagatedBuildInputs = [
    agate agate-excel agate-dbf agate-sql six
  ] ++ lib.optionals (!isPy3k) [
    argparse ordereddict simplejson
  ];

  checkInputs = [
    glibcLocales nose
  ] ++ lib.optionals (!isPy3k) [
    mock unittest2
  ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -e test_csvsql
  '';

  meta = with lib; {
    description = "A library of utilities for working with CSV, the king of tabular file formats";
    maintainers = with maintainers; [ vrthra ];
    license = with licenses; [ mit ];
    homepage = https://github.com/wireservice/csvkit;
  };
}
