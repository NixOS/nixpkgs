{ lib
, buildPythonPackage
, fetchPypi
, importlib-resources
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "asdf-standard";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "asdf_standard";
    inherit version;
    hash = "sha256-+3Rn41T2AHLru3FmFcOt1S8gqIIwOQQCcbmjlgZSKbU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [
    "asdf_standard"
  ];

  meta = with lib; {
    description = "Standards document describing ASDF";
    homepage = "https://github.com/asdf-format/asdf-standard";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
