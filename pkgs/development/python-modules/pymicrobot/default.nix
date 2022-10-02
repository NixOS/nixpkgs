{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymicrobot";
  version = "0.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "PyMicroBot";
    inherit version;
    hash = "sha256-BvxF/9bnA0oXCAXq1GXoR7AUnPF9hQLxmlOHxfYX+u8=";
  };

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "microbot"
  ];

  meta = with lib; {
    description = "Library to communicate with MicroBot";
    homepage = "https://github.com/spycle/pyMicroBot/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
