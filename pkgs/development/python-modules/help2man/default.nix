{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  jinja2,
  setuptools-scm,
  shtab,
  tomli,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "help2man";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "help2man";
    rev = version;
    hash = "sha256-BIDn+LQzBtDHUtFvIRL3NMXNouO3cMLibuYBoFtCUxI=";
  };

  build-system = [
    jinja2
    setuptools-scm
    shtab
    tomli
  ];

  dependencies = [ jinja2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # Checks the output of `help2man --help`.
    # Broken since 3.13 due to changes in `argparse`.
    # Upstream issue: https://github.com/Freed-Wu/help2man/issues/6
    "test_help"
  ];

  pythonImportsCheck = [ "help2man" ];

  meta = with lib; {
    description = "Convert --help and --version to man page";
    homepage = "https://github.com/Freed-Wu/help2man";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "help2man";
  };
}
