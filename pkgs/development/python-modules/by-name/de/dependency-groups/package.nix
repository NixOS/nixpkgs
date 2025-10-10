{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  packaging,
  pytestCheckHook,
  tomli,
}:

buildPythonPackage rec {
  pname = "dependency-groups";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "dependency-groups";
    tag = version;
    hash = "sha256-suuSx3zf0Y45FJdH8Cb6N7hcvPnzleREpHhtdiG2CLg=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    packaging
    tomli
  ];

  optional-dependencies = {
    cli = [
      tomli
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dependency_groups"
  ];

  meta = {
    description = "A standalone implementation of PEP 735 Dependency Groups";
    homepage = "https://github.com/pypa/dependency-groups";
    changelog = "https://github.com/pypa/dependency-groups/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
