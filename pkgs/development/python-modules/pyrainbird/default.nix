{
  lib,
  aiohttp-retry,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  parameterized,
  pycryptodome,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-golden,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests,
  requests-mock,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrainbird";
  version = "6.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "pyrainbird";
    rev = "refs/tags/${version}";
    hash = "sha256-CcoZZ60PItqy0bCc36WfyNF9Fc28aHwQ6hhnY41lBNg=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--cov=pyrainbird --cov-report=term-missing" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp-retry
    ical
    mashumaro
    pycryptodome
    python-dateutil
    pyyaml
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    parameterized
    pytest-aiohttp
    pytest-asyncio
    pytest-golden
    pytest-mock
    pytestCheckHook
    requests-mock
    responses
  ];

  pythonImportsCheck = [ "pyrainbird" ];

  meta = with lib; {
    description = "Module to interact with Rainbird controllers";
    homepage = "https://github.com/allenporter/pyrainbird";
    changelog = "https://github.com/allenporter/pyrainbird/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
