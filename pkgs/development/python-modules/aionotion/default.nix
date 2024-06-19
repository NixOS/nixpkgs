{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  certifi,
  ciso8601,
  fetchFromGitHub,
  frozenlist,
  mashumaro,
  poetry-core,
  pyjwt,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "aionotion";
  version = "2024.03.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aionotion";
    rev = "refs/tags/${version}";
    hash = "sha256-BsbfLb5wCVxR8v2U2Zzt7LMl7XJcZWfVjZN47VDkhFc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    certifi
    ciso8601
    frozenlist
    mashumaro
    pyjwt
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples" ];

  pythonImportsCheck = [ "aionotion" ];

  meta = with lib; {
    description = "Python library for Notion Home Monitoring";
    homepage = "https://github.com/bachya/aionotion";
    changelog = "https://github.com/bachya/aionotion/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
