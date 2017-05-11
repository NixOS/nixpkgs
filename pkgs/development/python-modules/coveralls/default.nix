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
  version = "1.1";

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "0238hgdwbvriqxrj22zwh0rbxnhh9c6hh75i39ll631vq62h65il";
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


