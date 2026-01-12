{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "dissect-evidence";
  version = "3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.evidence";
    tag = version;
    hash = "sha256-kSM2fXaK3H6os/RexwOGg2d8UptoAlHnYK7FlMTg2bI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/fox-it/dissect.evidence/issues/46
    "test_ewf"
  ];

  pythonImportsCheck = [ "dissect.evidence" ];

  meta = {
    description = "Dissect module implementing a parsers for various forensic evidence file containers";
    homepage = "https://github.com/fox-it/dissect.evidence";
    changelog = "https://github.com/fox-it/dissect.evidence/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
