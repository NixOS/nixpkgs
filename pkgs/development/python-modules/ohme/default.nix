{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ohme";
  version = "1.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dan-r";
    repo = "ohmepy";
    tag = "v${version}";
    hash = "sha256-hCwaB6YXtNHCNOyjRxDSonBdTpKqX9GmLwFMvrY9UpI=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "ohme" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for interacting with the Ohme API";
    homepage = "https://github.com/dan-r/ohmepy";
    changelog = "https://github.com/dan-r/ohmepy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
