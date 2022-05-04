{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "2.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CircleUp";
    repo = pname;
    rev = version;
    sha256 = "sha256-9ZzIrj87TwxQi0YMlTHFPAp0V1oxfuL0+RMGXxUxFoE=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  buildInputs = [
    pytest
    pytest-asyncio
  ];

  checkInputs = [
    aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests which requires network access
    "test_foo"
    "test_passthrough"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "aresponses"
  ];

  meta = with lib; {
    description = "Asyncio testing server";
    homepage = "https://github.com/circleup/aresponses";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}

