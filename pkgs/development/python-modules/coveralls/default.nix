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
  version = "3.2.0";
  disabled = isPy27;

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "15a987d9df877fff44cd81948c5806ffb6eafb757b3443f737888358e96156ee";
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


