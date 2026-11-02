{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "orgformat";
  version = "0-unstable-2024-10-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "novoid";
    repo = "orgformat";
    rev = "5346cc1a5fd670981e9b1d0bbd215eb5c79040d4";
    hash = "sha256-4MnA+OzmEGN3KzjsZVwBXASiYTg529cfghpuf4owYJ8=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "orgformat"
  ];

  meta = {
    description = "Utility library for providing functions to generate and modify Org mode syntax elements like links, time-stamps, or date-stamps";
    homepage = "https://github.com/novoid/orgformat";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ confusedalex ];
  };
}
