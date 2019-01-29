{ lib, fetchPypi, buildPythonPackage, isPy3k
, agate, agate-excel, agate-dbf, agate-sql, six
, ordereddict, simplejson
, glibcLocales, nose, mock, unittest2
}:

buildPythonPackage rec {
  pname = "csvkit";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6c859c1321d4697dc41252877249091681297f093e08d9c1e1828a6d52c260c";
  };

  propagatedBuildInputs = [
    agate agate-excel agate-dbf agate-sql six
  ] ++ lib.optionals (!isPy3k) [
    ordereddict simplejson
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
