{
  lib,
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
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "plugwise";
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
    hash = "sha256-CVgcqyg5DDtEJxE/oen5MJP+mV4B+Sq0uopEZTOCfV0=";
  };

  postPatch = ''
    # setuptools and wheel
    sed -i -e "s/~=[0-9.]*//g" pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
