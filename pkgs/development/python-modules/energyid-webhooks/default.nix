{
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "energyid-webhooks";
  version = "0.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnergieID";
    repo = "energyid-webhooks-py";
    tag = "v${version}";
    hash = "sha256-tH+uAsL67/MZrjcAXtIyW6x9XBLa2SFyknpLaBIqPYA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    backoff
    requests
  ];

  pythonImportsCheck = [ "energyid_webhooks" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Light weight Python package to interface with EnergyID Webhooks";
    homepage = "https://github.com/EnergieID/energyid-webhooks-py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
