{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, pythonOlder
, coverage
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XCjXcKC5pwKGK9bDdVuizS95lN1RjJguXOKY1/N0ZqQ=";
  };

  propagatedBuildInputs = [
    coverage
    six
  ];

  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [
    "nose2"
  ];

  meta = with lib; {
    description = "Test runner for Python";
    homepage = "https://github.com/nose-devs/nose2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
