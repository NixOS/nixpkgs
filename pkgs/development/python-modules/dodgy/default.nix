{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # pythonPackages
  mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dodgy";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prospector-dev";
    repo = "dodgy";
    rev = version;
    hash = "sha256-HUhwrOKTAH4QDJTe146ctGhDccqyWRouHJqaC/6VnHs=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/test_checks.py" ];

  meta = {
    description = "Looks at Python code to search for things which look \"dodgy\" such as passwords or diffs";
    mainProgram = "dodgy";
    homepage = "https://github.com/prospector-dev/dodgy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
