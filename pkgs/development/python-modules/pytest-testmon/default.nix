{ lib
, buildPythonPackage
, coverage
, fetchPypi
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PVLXOBTo2xnMBM4wyvrmGgyztW0ajGxMU+oIhrjZiw8=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    coverage
  ];

  # The project does not include tests since version 1.3.0
  doCheck = false;

  pythonImportsCheck = [
    "testmon"
  ];

  meta = with lib; {
    description = "Pytest plug-in which automatically selects and re-executes only tests affected by recent changes";
    homepage = "https://github.com/tarpas/pytest-testmon/";
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
  };
}
