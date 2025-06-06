{
  lib,
  asyncio-dgram,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pytest-asyncio,
  pytest-rerunfailures,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "11.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "py-mine";
    repo = "mcstatus";
    tag = "v${version}";
    hash = "sha256-P8Su5P/ztyoXZBVvm5uCMDn4ezeg11oRSQ0QCyIJbVw=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    asyncio-dgram
    dnspython
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-rerunfailures
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mcstatus" ];

  disabledTests = [
    # DNS features are limited in the sandbox
    "test_query"
    "test_query_retry"
    "test_resolve_localhost"
    "test_async_resolve_localhost"
  ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    mainProgram = "mcstatus";
    homepage = "https://github.com/py-mine/mcstatus";
    changelog = "https://github.com/py-mine/mcstatus/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
