{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asysocks,
}:

buildPythonPackage rec {
  pname = "unidns";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "unidns";
    tag = version;
    hash = "sha256-uhTb27HeBaoI4yURpNf1+D6bWIXSsmYzUyk0RJmgbjQ=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "asysocks"
  ];

  dependencies = [
    asysocks
  ];

  # No tests provided
  doCheck = false;

  pythonImportsCheck = [
    "unidns"
  ];

  meta = {
    description = "Basic async DNS library";
    homepage = "https://github.com/skelsec/unidns";
    changelog = "https://github.com/skelsec/unidns/releases/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
