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
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiojellyfin";
    tag = "v${version}";
    hash = "sha256-M9GsXcm2PM3blkMBMrjyagzcWpyt/WqMeM8xU/KNPks=";
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
