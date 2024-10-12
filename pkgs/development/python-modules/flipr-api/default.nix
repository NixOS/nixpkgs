{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests-mock,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  requests,
}:

buildPythonPackage rec {
  pname = "flipr-api";
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cnico";
    repo = "flipr-api";
    rev = "refs/tags/${version}";
    hash = "sha256-/px8NuBwukAPMxdXvHdyfO/j/a9UatKbdrjDNuT0f4k=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    pytest-asyncio
    pytestCheckHook
  ];

  env = {
    # used in test_session
    FLIPR_USERNAME = "foobar";
    FLIPR_PASSWORD = "secret";
  };

  pythonImportsCheck = [ "flipr_api" ];

  meta = with lib; {
    description = "Python client for Flipr API";
    mainProgram = "flipr-api";
    homepage = "https://github.com/cnico/flipr-api";
    changelog = "https://github.com/cnico/flipr-api/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
