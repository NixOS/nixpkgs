{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "airgradient";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "airgradienthq";
    repo = "python-airgradient";
    rev = "refs/tags/v${version}";
    hash = "sha256-1miNMT4AiOEci/jfZJswaF/Dee0bCNH7CLiKoR443q0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "airgradient" ];

  meta = with lib; {
    description = "Module for AirGradient";
    homepage = "https://github.com/airgradienthq/python-airgradient";
    changelog = "https://github.com/airgradienthq/python-airgradient/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
