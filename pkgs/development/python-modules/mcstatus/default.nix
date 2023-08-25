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
  version = "11.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "py-mine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1jPIsFEJ17kjtCBiX4IvSf2FxYw9DkH3MrrJ85N71tc=";
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
  ];

  meta = with lib; {
    description = "Python library for checking the status of Minecraft servers";
    homepage = "https://github.com/py-mine/mcstatus";
    changelog = "https://github.com/py-mine/mcstatus/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
