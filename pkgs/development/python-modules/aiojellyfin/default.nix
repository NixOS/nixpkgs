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
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiojellyfin";
    rev = "v${version}";
    hash = "sha256-D4/DlhCeeI4CggW7KGauZ57fHY92JM/kZSUODyNVcNg=";
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
    changelog = "https://github.com/Jc2k/aiojellyfin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
