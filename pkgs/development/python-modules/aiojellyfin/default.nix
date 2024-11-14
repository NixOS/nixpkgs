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
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = "aiojellyfin";
    rev = "refs/tags/v${version}";
    hash = "sha256-A+uvM1/7HntRMIdknfHr0TMGIjHk7BCwsZopXdVoEO8=";
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
