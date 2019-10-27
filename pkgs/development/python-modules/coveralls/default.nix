{ buildPythonPackage
, lib
, fetchPypi
, mock
, pytest
, pytestrunner
, sh
, coverage
, docopt
, requests
, urllib3
, git
, isPy3k
}:

buildPythonPackage rec {
  pname = "coveralls";
  name = "${pname}-python-${version}";
  version = "1.5.1";

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "ab638e88d38916a6cedbf80a9cd8992d5fa55c77ab755e262e00b36792b7cd6d";
  };

  checkInputs = [
    mock
    sh
    pytest
    git
  ];

  buildInputs = [
    pytestrunner
  ];

  # FIXME: tests requires .git directory to be present
  doCheck = false;

  checkPhase = ''
    python setup.py test
  '';

  propagatedBuildInputs = [
    coverage
    docopt
    requests
  ] ++ lib.optional (!isPy3k) urllib3;

  meta = {
    description = "Show coverage stats online via coveralls.io";
    homepage = https://github.com/coveralls-clients/coveralls-python;
    license = lib.licenses.mit;
  };
}


