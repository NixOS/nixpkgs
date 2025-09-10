{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  pysocks,
  pythonOlder,
  requests,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyowm";
  version = "3.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csparpa";
    repo = "pyowm";
    tag = version;
    hash = "sha256-D1Cl3uWoEIUqA0R+bjRL2YgsVKj5inuBAVLJYluADg0=";
  };

  pythonRelaxDeps = [ "geojson" ];

  build-system = [ setuptools ];

  dependencies = [
    geojson
    pysocks
    requests
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Run only tests which don't require network access
  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "pyowm" ];

  meta = with lib; {
    description = "Python wrapper around the OpenWeatherMap web API";
    homepage = "https://pyowm.readthedocs.io/";
    changelog = "https://github.com/csparpa/pyowm/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
