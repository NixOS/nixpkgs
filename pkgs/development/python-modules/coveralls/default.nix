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
  version = "2.0.0";

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "1d82hs79vjpa6ydgqyhlb0kmywhpzsmwq5mk1lzx0lwhsknza4yj";
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
    homepage = "https://github.com/coveralls-clients/coveralls-python";
    license = lib.licenses.mit;
  };
}
