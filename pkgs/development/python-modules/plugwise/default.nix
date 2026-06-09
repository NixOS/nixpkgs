{
  lib,
  aiofiles,
  aiohttp,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  freezegun,
  jsonpickle,
  munch,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "plugwise";
  version = "1.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plugwise";
    repo = "python-plugwise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V1oPSRO+Adacszy8Wh5u4sHzVvfwiKvdKMzFi58pC2E=";
  };

  postPatch = ''
    # setuptools and wheel
    sed -i -e "s/~=[0-9.]*//g" pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    defusedxml
    munch
    python-dateutil
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

  meta = {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    homepage = "https://github.com/plugwise/python-plugwise";
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
