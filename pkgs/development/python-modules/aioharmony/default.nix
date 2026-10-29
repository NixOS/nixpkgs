{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  slixmpp,
}:

buildPythonPackage rec {
  pname = "aioharmony";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Harmony-Libs";
    repo = "aioharmony";
    tag = "v${version}";
    hash = "sha256-163L2ilmfMRL6qsD4RgWEX3kdKK6rnvjw9c78vKBtuE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    slixmpp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioharmony.harmonyapi"
    "aioharmony.harmonyclient"
  ];

  meta = {
    homepage = "https://github.com/Harmony-Libs/aioharmony";
    description = "Python library for interacting the Logitech Harmony devices";
    mainProgram = "aioharmony";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oro ];
  };
}
