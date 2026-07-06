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
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plugwise";
    repo = "python-plugwise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gvTvKhs54jWvBCHBbNN2UiMMpJ+bEwAsRJsN/EzE72Y=";
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
