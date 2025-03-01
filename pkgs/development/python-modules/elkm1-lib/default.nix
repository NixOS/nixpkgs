{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "elkm1-lib";
  version = "2.2.11";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "gwww";
    repo = "elkm1";
    tag = version;
    hash = "sha256-wi115LppK628EBw3AFeQHNnLv51dcfaZZi5R6S9+WJE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    async-timeout
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "elkm1_lib" ];

  meta = with lib; {
    description = "Python module for interacting with ElkM1 alarm/automation panel";
    homepage = "https://github.com/gwww/elkm1";
    changelog = "https://github.com/gwww/elkm1/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
