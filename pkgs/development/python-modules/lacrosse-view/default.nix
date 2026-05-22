{
  lib,
  aiohttp,
  aiozoneinfo,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lacrosse-view";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IceBotYT";
    repo = "lacrosse_view";
    tag = "v${version}";
    hash = "sha256-KU3/w/LpbDNmrE70wj7j1ztKn+k4wP6RzvUU1p50i2A=";
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
