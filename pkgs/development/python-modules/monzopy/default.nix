{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "monzopy";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "JakeMartin-ICL";
    repo = "monzopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-AoBfcQ0rilUPMvLCjU2Y+P/wVnb+I40vmq+5lS5eSto=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "monzopy" ];

  meta = with lib; {
    description = "Module to work with the Monzo API";
    homepage = "https://github.com/JakeMartin-ICL/monzopy";
    changelog = "https://github.com/JakeMartin-ICL/monzopy/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
