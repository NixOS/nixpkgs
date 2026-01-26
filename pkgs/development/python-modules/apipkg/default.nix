{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "apipkg";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "apipkg";
    tag = "v${version}";
    hash = "sha256-ANLD7fUMKN3RmAVjVkcpwUH6U9ASalXdwKtPpoC8Urs=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test_apipkg.py" ];

  pythonImportsCheck = [ "apipkg" ];

  meta = {
    changelog = "https://github.com/pytest-dev/apipkg/blob/main/CHANGELOG";
    description = "Namespace control and lazy-import mechanism";
    homepage = "https://github.com/pytest-dev/apipkg";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
