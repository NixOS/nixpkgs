{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "breame";
  version = "0.1.2-unstable-2021-10-04"; # no tagged release upstream
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdpierse";
    repo = "breame";
    rev = "1bd0758ff625b155e5bc3687e6c614a8755b0e6d";
    hash = "sha256-5iUjqftI0C+LN2H84Ch0fsdEGrqWWp9gu5LzJkSoIZM=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "breame"
  ];

  meta = {
    description = "British and American English tooling for detecting and providing definitions for words with dual spellings";
    homepage = "https://github.com/cdpierse/breame";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
})
