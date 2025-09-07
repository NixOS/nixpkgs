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
    owner = "landscapeio";
    repo = "dodgy";
    rev = version;
    sha256 = "0ywwjpz0p6ls3hp1lndjr9ql6s5lkj7dgpll1h87w04kwan70j0x";
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
    homepage = "https://github.com/landscapeio/dodgy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
}
