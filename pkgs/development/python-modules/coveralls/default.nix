{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, mock
, pytest
, pytest-runner
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
  version = "3.1.0";
  disabled = isPy27;

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "9b3236e086627340bf2c95f89f757d093cbed43d17179d3f4fb568c347e7d29a";
  };

  checkInputs = [
    mock
    sh
    pytest
    git
  ];

  buildInputs = [
    pytest-runner
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


