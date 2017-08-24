{ buildPythonPackage
, lib
, fetchPypi
, mock
, pytest_27
, sh
, coverage
, docopt
, requests
, git
}:

buildPythonPackage rec {
  pname = "coveralls";
  name = "${pname}-python-${version}";
  version = "1.2.0";

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "510682001517bcca1def9f6252df6ce730fcb9831c62d9fff7c7d55b6fdabdf3";
  };

  buildInputs = [
    mock
    sh
    pytest_27
    git
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
  ];

  meta = {
    description = "Show coverage stats online via coveralls.io";
    homepage = https://github.com/coveralls-clients/coveralls-python;
    license = lib.licenses.mit;
  };
}


