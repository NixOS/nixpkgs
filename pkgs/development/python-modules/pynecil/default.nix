{
  aiohttp,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  lib,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynecil";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pynecil";
    tag = "v${version}";
    hash = "sha256-ZEg5fmSE594YEgcJROOeVqc1reyGlyQiYNoCcfUanrY=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [
    aiohttp
    bleak
    bleak-retry-connector
  ];

  pythonImportsCheck = [ "pynecil" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # requires access to system D-Bus
    "test_get_settings_communication_error"
  ];

  meta = {
    changelog = "https://github.com/tr4nt0r/pynecil/releases/tag/${src.tag}";
    description = "Python library to communicate with Pinecil V2 soldering irons via Bluetooth";
    homepage = "https://github.com/tr4nt0r/pynecil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
