{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  mypy,
}:

buildPythonPackage rec {
  pname = "orderly-set";
  version = "5.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "orderly-set";
    rev = "refs/tags/${version}";
    hash = "sha256-iQgPTBkyuBqDz64Tws+cqvTgp0UCD8C/5GoTik/mdrE=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "orderly_set"
  ];
  nativeCheckInputs = [
    pytestCheckHook
    mypy
  ];

  meta = {
    description = "Orderly Set previously known as Ordered Set";
    homepage = "https://github.com/seperman/orderly-set";
    changelog = "https://github.com/seperman/orderly-set/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
