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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "plugwise";
  version = "1.7.8";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "plugwise";
    repo = "python-plugwise";
    tag = "v${version}";
    hash = "sha256-hGXjwEOvcSIvfw3xeIUVF59bSXjVXL7CMUncHqeVZ1Y=";
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

  meta = with lib; {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    homepage = "https://github.com/plugwise/python-plugwise";
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
