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
  version = "2.2.0";
  disabled = isPy27;

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "b990ba1f7bc4288e63340be0433698c1efe8217f78c689d254c2540af3d38617";
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


