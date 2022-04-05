{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.29";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5mhR+Ey8RrruucUIt5LxBNM6OBUWbLy5jNOWg6tzxRE=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "dotmap/test.py"
  ];

  pythonImportsCheck = [
    "dotmap"
  ];

  meta = with lib; {
    description = "Python for dot-access dictionaries";
    homepage = "https://github.com/drgrib/dotmap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
