{ lib
, buildPythonPackage
, fetchPypi
, pip
, pretend
, pytestCheckHook
, pythonOlder
, virtualenv
}:

buildPythonPackage rec {
  pname = "pip-api";
  version = "0.0.28";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yqu2l/QKLPpnJkBae5DI/ReU7DnqOD+lMTs/8O6I8AE=";
  };

  propagatedBuildInputs = [
    pip
  ];

  checkInputs = [
    pretend
    pytestCheckHook
    virtualenv
  ];

  pythonImportsCheck = [
    "pip_api"
  ];

  disabledTests = [
    "test_hash"
    "test_hash_default_algorithm_is_256"
    "test_installed_distributions"
    "test_invoke_install"
    "test_invoke_uninstall"
    "test_isolation"
  ];

  meta = with lib; {
    description = "Importable pip API";
    homepage = "https://github.com/di/pip-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
