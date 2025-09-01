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
  pytest-cov-stub,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "aionotion";
  version = "2025.02.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aionotion";
    tag = version;
    hash = "sha256-MqH3CPp+dAX5DXtnHio95KGQ+Ok2TXrX6rn/AMx5OsY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core==" "poetry-core>="
  '';

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

  pythonRelaxDeps = [
    "ciso8601"
    "frozenlist"
    "mashumaro"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples" ];

  pythonImportsCheck = [ "aionotion" ];

  meta = with lib; {
    description = "Python library for Notion Home Monitoring";
    homepage = "https://github.com/bachya/aionotion";
    changelog = "https://github.com/bachya/aionotion/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
