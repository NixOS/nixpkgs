{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  packaging,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dependency-groups";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "dependency-groups";
    rev = version;
    hash = "sha256-suuSx3zf0Y45FJdH8Cb6N7hcvPnzleREpHhtdiG2CLg=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  optional-dependencies = {
    cli = [ ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dependency_groups" ];

  meta = {
    description = "Standalone implementation of PEP 735 Dependency Groups";
    homepage = "https://github.com/pypa/dependency-groups";
    changelog = "https://github.com/pypa/dependency-groups/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
