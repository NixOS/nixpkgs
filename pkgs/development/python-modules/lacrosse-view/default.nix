{
  lib,
  aiohttp,
  aiozoneinfo,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lacrosse-view";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "IceBotYT";
    repo = "lacrosse_view";
    tag = "v${version}";
    hash = "sha256-fIeVRqGEL79pOl/zAk3nrrgOgfvlujjK3sFfPVWfUxM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiozoneinfo
    pydantic
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "lacrosse_view" ];

  meta = {
    description = "Client for retrieving data from the La Crosse View cloud";
    homepage = "https://github.com/IceBotYT/lacrosse_view";
    changelog = "https://github.com/IceBotYT/lacrosse_view/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
