{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "adguardhome";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-${pname}";
    tag = "v${version}";
    hash = "sha256-n55G6ulKcgSSrgPk70D52OO9fp3WURlcRhJQUKrZ1Nk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "adguardhome" ];

  meta = with lib; {
    description = "Python client for the AdGuard Home API";
    homepage = "https://github.com/frenck/python-adguardhome";
    changelog = "https://github.com/frenck/python-adguardhome/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
