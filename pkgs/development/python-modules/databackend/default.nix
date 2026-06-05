{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pip-tools,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "databackend";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "machow";
    repo = "databackend";
    tag = "v${version}";
    hash = "sha256-M5Nm33Vae6FDy4aurru4CeHjeNxyZZnqzpdkqNEvrm0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pip-tools
  ];

  pythonImportsCheck = [ "databackend" ];

  meta = {
    description = "Module to register a subclass, without needing to import the subclass itself";
    homepage = "https://github.com/machow/databackend";
    changelog = "https://github.com/machow/databackend/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
