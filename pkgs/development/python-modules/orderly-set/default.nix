{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "orderly-set";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seperman";
    repo = "orderly-set";
    tag = version;
    hash = "sha256-8tqQR8Oa/1jcfokBVKdvsC7Ya26bn0XHM9/QsstM07E=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "orderly_set"
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];
  disabledTests = [
    # Statically analyzes types, can be disabled so that mypy won't be needed.
    "test_typing_mypy"
  ];

  meta = {
    description = "Multiple implementations of Ordered Set";
    homepage = "https://github.com/seperman/orderly-set";
    changelog = "https://github.com/seperman/orderly-set/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
