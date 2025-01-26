{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Freed-Wu";
    repo = "help2man";
    tag = version;
    hash = "sha256-BIDn+LQzBtDHUtFvIRL3NMXNouO3cMLibuYBoFtCUxI=";
  };

  patches = lib.optionals (!pythonOlder "3.13") [
    # https://github.com/Freed-Wu/help2man/issues/6
    ./0001-python-3.13.patch
  ];

  build-system = [
    setuptools-scm
  ];

  nativeBuildInputs = [
    jinja2
    shtab
    tomli
  ];

  dependencies = [ jinja2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "help2man" ];

  meta = {
    description = "Convert --help and --version to man page";
    homepage = "https://github.com/Freed-Wu/help2man";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "help2man";
  };
}
