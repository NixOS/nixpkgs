{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aioeagle";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioeagle";
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "Python library to control EAGLE-200";
    homepage = "https://github.com/home-assistant-libs/aioeagle";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
