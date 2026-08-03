{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyairnow";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asymworks";
    repo = "pyairnow";
    tag = "v${version}";
    hash = "sha256-g2WuknWP7FKhjM+mCJ92gsfXO2NrAkBbFOExoztudnA=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyairnow" ];

  meta = {
    description = "Python wrapper for EPA AirNow Air Quality API";
    homepage = "https://github.com/asymworks/pyairnow";
    changelog = "https://github.com/asymworks/pyairnow/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
