{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tomli,
}:

buildPythonPackage rec {
  pname = "dependency-groups";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    tag = version;
    hash = "sha256-suuSx3zf0Y45FJdH8Cb6N7hcvPnzleREpHhtdiG2CLg=";
  };

  build-system = [ flit-core ];

  dependencies = [
    packaging
  ]
  ++ lib.optional (pythonOlder "3.11") tomli;

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "dependency_groups" ];

  meta = {
    description = "Standalone implementation of PEP 735 Dependency Groups";
    homepage = "https://github.com/pypa/dependency-groups";
    changelog = "https://github.com/pypa/dependency-groups/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jemand771
    ];
  };
}
