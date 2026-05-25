{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyemoncms";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Open-Building-Management";
    repo = "pyemoncms";
    tag = "v${version}";
    hash = "sha256-Bvcnl3av9SF0CNUjg/QDdvENIEgPg26fAJ522jBrL7Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "pyemoncms" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTests = [
    # requires networking
    "test_timeout"
  ];

  meta = {
    changelog = "https://github.com/Open-Building-Management/pyemoncms/releases/tag/${src.tag}";
    description = "Python library for emoncms API";
    homepage = "https://github.com/Open-Building-Management/pyemoncms";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
