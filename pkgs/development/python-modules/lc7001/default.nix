{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, pythonOlder
, poetry-core
}:

buildPythonPackage rec {
  pname = "lc7001";
  version = "1.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1qObmGpu6mU3gdxS8stH+4Zc2NA7W1+pS7fOXALC0Ug=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lc7001"
  ];

  meta = with lib; {
    description = "Python module for interacting with Legrand LC7001";
    homepage = "https://github.com/rtyle/lc7001";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
