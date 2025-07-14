{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  mashumaro,

  # tests
  pytestCheckHook,
  pytest-aiohttp,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "aiojellyfin";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiojellyfin";
    tag = "v${version}";
    hash = "sha256-C2jIP2q+1z6iQoK18jRVaFKXtxyF1RXZMtXWakx7qO0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "aiojellyfin" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/Jc2k/aiojellyfin";
    changelog = "https://github.com/Jc2k/aiojellyfin/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
