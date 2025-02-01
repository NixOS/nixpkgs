{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  metar,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pynws";
  version = "1.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = "pynws";
    rev = "refs/tags/v${version}";
    hash = "sha256-gC5IOW5sejXigBKfxLst8MwU/IkqSQrMZhmd4eza++s=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    metar
  ];

  optional-dependencies.retry = [ tenacity ];

  nativeCheckInputs = [
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "pynws" ];

  meta = with lib; {
    description = "Python library to retrieve data from NWS/NOAA";
    homepage = "https://github.com/MatthewFlamm/pynws";
    changelog = "https://github.com/MatthewFlamm/pynws/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
