{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyotgw";
  version = "2.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = "pyotgw";
    tag = version;
    hash = "sha256-BQgRWXBSmB9AzpPeTJP7motJeKF2G0tyqJpbwIwnxwk=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial-asyncio-fast ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyotgw" ];

  disabledTests = [
    # Tests require network access
    "connect_timeouterror"
  ];

  meta = with lib; {
    description = "Python module to interact the OpenTherm Gateway";
    homepage = "https://github.com/mvn23/pyotgw";
    changelog = "https://github.com/mvn23/pyotgw/blob/${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
