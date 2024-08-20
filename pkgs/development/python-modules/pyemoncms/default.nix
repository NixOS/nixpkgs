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
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Open-Building-Management";
    repo = "pyemoncms";
    rev = "refs/tags/v${version}";
    hash = "sha256-IBrYys0i9pTAw9ul8bqni0H3KNSvKQYNU6D4OSfR6ZE=";
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
    changelog = "https://github.com/Open-Building-Management/pyemoncms/releases/tag/v${version}";
    description = "Python library for emoncms API";
    homepage = "https://github.com/Open-Building-Management/pyemoncms";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
