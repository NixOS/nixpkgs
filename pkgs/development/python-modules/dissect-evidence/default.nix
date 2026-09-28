{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pycryptodome,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "dissect-evidence";
  version = "3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.evidence";
    tag = finalAttrs.version;
    fetchLFS = true;
    hash = "sha256-oix0CSsVqBM5udzePa/leabw5sOB8VfLFTB9e46sTD0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  optional-dependencies = {
    full = [ pycryptodome ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/fox-it/dissect.evidence/issues/46
    "test_ewf"
  ];

  pythonImportsCheck = [ "dissect.evidence" ];

  meta = {
    description = "Dissect module implementing a parsers for various forensic evidence file containers";
    homepage = "https://github.com/fox-it/dissect.evidence";
    changelog = "https://github.com/fox-it/dissect.evidence/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
