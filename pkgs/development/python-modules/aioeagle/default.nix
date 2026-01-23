{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aioeagle";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioeagle";
    tag = version;
    hash = "sha256-ZO5uODCGebggItsEVKtis0uwU67dmSxc7DHzzkBZ9oQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioeagle" ];

  meta = {
    description = "Python library to control EAGLE-200";
    homepage = "https://github.com/home-assistant-libs/aioeagle";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
