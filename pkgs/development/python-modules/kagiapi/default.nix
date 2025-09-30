{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "kagiapi";
  version = "0.2.1-unstable-2025-04-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kagisearch";
    repo = "kagiapi";
    rev = "53176fbd98cf880105b901dea9a1a8e623f25e1b";
    sha256 = "sha256-Z0JFwQlG672lehogam8GyIcELCaoxBD0w4tkNBMjxQ8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    requests
    typing-extensions
  ];

  pythonImportsCheck = [
    "kagiapi"
  ];

  meta = {
    description = "Python package for Kagi Search API";
    homepage = "https://github.com/kagisearch/kagiapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ etwas ];
    mainProgram = "kagiapi";
  };
}
