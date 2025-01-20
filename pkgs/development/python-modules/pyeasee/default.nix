{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  aioresponses,
  aiohttp,
  pysignalr,
}:

buildPythonPackage rec {
  pname = "pyeasee";
  version = "0.8.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nordicopen";
    repo = "pyeasee";
    tag = "v${version}";
    hash = "sha256-bJWSj8dYwQHcgRNAHmCJp68dYr1+Ie2I+TbVJanC5IQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    aioresponses
    pytest-asyncio
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pysignalr
  ];

  meta = {
    description = "Easee EV charger API python library";
    homepage = "https://github.com/nordicopen/pyeasee";
    changelog = "https://github.com/nordicopen/pyeasee/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
