{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  crcmod,
  defusedxml,
  fetchFromGitHub,
  freezegun,
  jsonpickle,
  munch,
  pyserial,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  semver,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "plugwise";
  version = "0.38.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "plugwise";
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
    hash = "sha256-IearyHkIH3iJyIGqdJetg3cu0kvEpZLgI0sotxpQWyw=";
  };

  postPatch = ''
    # setuptools
    sed -i -e "s/~=[0-9.]*//" pyproject.toml
    # wheel
    sed -i -e "s/~=[0-9.]*//" pyproject.toml
  '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    aiohttp
    async-timeout
    crcmod
    defusedxml
    munch
    pyserial
    python-dateutil
    semver
  ];

  nativeCheckInputs = [
    freezegun
    jsonpickle
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "plugwise" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    homepage = "https://github.com/plugwise/python-plugwise";
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
