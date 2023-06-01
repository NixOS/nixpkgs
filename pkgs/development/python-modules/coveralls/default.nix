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
  version = "3.3.1";
  disabled = isPy27;

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "b32a8bb5d2df585207c119d6c01567b81fba690c9c10a753bfe27a335bfc43ea";
  };

  nativeCheckInputs = [
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


