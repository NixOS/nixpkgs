{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.30";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCGnkz8HX7R1Y0F8DpLgt8AxFYtMmmp+VhY0ebZYs2g=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "dotmap/test.py" ];

  pythonImportsCheck = [ "dotmap" ];

  meta = {
    description = "Python for dot-access dictionaries";
    homepage = "https://github.com/drgrib/dotmap";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
