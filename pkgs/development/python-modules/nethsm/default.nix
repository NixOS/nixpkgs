{
  lib,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchFromGitHub,
  poetry-core,
  pycryptodome,
  pytestCheckHook,
  python-dateutil,
  typing-extensions,
  urllib3,
}:

buildPythonPackage rec {
  pname = "nethsm";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nethsm-sdk-py";
    tag = "v${version}";
    hash = "sha256-3Fc2DH3nuMA6aRl1fUiQJTH7RkWqht9JmoZQJSgF5Rs=";
  };

  pythonRelaxDeps = true;

  build-system = [ poetry-core ];

  dependencies = [
    certifi
    cryptography
    python-dateutil
    typing-extensions
    urllib3
  ];

  nativeCheckInputs = [
    pycryptodome
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nethsm" ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "tests/test_nethsm_config.py"
    "tests/test_nethsm_keys.py"
    "tests/test_nethsm_namespaces.py"
    "tests/test_nethsm_other.py"
    "tests/test_nethsm_system.py"
    "tests/test_nethsm_users.py"
  ];

  meta = {
    description = "Client-side Python SDK for NetHSM";
    homepage = "https://github.com/Nitrokey/nethsm-sdk-py";
    changelog = "https://github.com/Nitrokey/nethsm-sdk-py/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
