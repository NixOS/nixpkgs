{ buildPythonPackage
, lib
, fetchPypi
, isPy27
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
  version = "3.0.1";
  disabled = isPy27;

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "cbb942ae5ef3d2b55388cb5b43e93a269544911535f1e750e1c656aef019ce60";
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

  postPatch = ''
    sed -i "s/'coverage>=\([^,]\+\),.*',$/'coverage>=\1',/" setup.py
  '';

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
    homepage = "https://github.com/coveralls-clients/coveralls-python";
    license = lib.licenses.mit;
  };
}


