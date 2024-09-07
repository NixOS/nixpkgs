{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.30";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCGnkz8HX7R1Y0F8DpLgt8AxFYtMmmp+VhY0ebZYs2g=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "dotmap/test.py" ];

  pythonImportsCheck = [ "dotmap" ];

  meta = with lib; {
    description = "Python for dot-access dictionaries";
    homepage = "https://github.com/drgrib/dotmap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
