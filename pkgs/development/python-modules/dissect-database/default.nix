{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dissect-database";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.database";
    tag = finalAttrs.version;
    hash = "sha256-z3Ra8BjPGozcx5bF+FKcA/bnsO8F++UBUEQ2tBd+X5Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  # Test files are not ready
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.database" ];

  meta = {
    description = "Dissect module implementing a parser for various database formats";
    homepage = "https://github.com/fox-it/dissect.database";
    changelog = "https://github.com/fox-it/dissect.database/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
