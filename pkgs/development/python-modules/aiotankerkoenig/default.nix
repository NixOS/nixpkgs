{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiotankerkoenig";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "aiotankerkoenig";
    tag = "v${version}";
    hash = "sha256-TpSVRo8FWltZF5ZQx9kZ3mlJ1bEHVWmIdLVSyaKjj04=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiotankerkoenig" ];

  meta = {
    description = "Python module for interacting with tankerkoenig.de";
    homepage = "https://github.com/jpbede/aiotankerkoenig";
    changelog = "https://github.com/jpbede/aiotankerkoenig/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
