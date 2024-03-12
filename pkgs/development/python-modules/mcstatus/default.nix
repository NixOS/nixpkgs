{ lib
, asyncio-dgram
, buildPythonPackage
, dnspython
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, pytest-asyncio
, pytest-rerunfailures
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mcstatus";
  version = "11.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "py-mine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-P8Su5P/ztyoXZBVvm5uCMDn4ezeg11oRSQ0QCyIJbVw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=mcstatus --cov-append --cov-branch --cov-report=term-missing -vvv --no-cov-on-fail" ""
  '';

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
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mcstatus"
  ];

  disabledTests = [
    # DNS features are limited in the sandbox
    "test_query"
    "test_query_retry"
    "test_resolve_localhost"
    "test_async_resolve_localhost"
  ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    homepage = "https://github.com/py-mine/mcstatus";
    changelog = "https://github.com/py-mine/mcstatus/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
