{
  lib,
  asyncio-dgram,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-rerunfailures,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "12.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-mine";
    repo = "mcstatus";
    tag = "v${version}";
    hash = "sha256-FSXELbEQYUUu2maWBFb5Fj7Y3zXqwmFQRAu+nNco0lQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    asyncio-dgram
    dnspython
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-rerunfailures
    pytest-cov-stub
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "mcstatus" ];

  disabledTests = [
    # DNS features are limited in the sandbox
    "test_resolve_localhost"
    "test_async_resolve_localhost"
    "test_java_server_with_query_port"
  ];

  meta = {
    description = "Python library for checking the status of Minecraft servers";
    mainProgram = "mcstatus";
    homepage = "https://github.com/py-mine/mcstatus";
    changelog = "https://github.com/py-mine/mcstatus/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      fab
      perchun
    ];
  };
}
