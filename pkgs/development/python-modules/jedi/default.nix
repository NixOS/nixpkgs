{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  parso,

  # tests
  attrs,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jedi";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D0Zy8HJYq5l8Wp1M+J7p8Z+EBY/R5tYFa2uMYiqLIT8=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [ parso ];

  nativeCheckInputs = [
    attrs
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # sensitive to platform, causes false negatives on darwin
      "test_import"
    ]
    ++ lib.optionals stdenv.targetPlatform.useLLVM [
      # InvalidPythonEnvironment: The python binary is potentially unsafe.
      "test_create_environment_executable"
      # AssertionError: assert ['', '.1000000000000001'] == ['', '.1']
      "test_dict_keys_completions"
      # AssertionError: assert ['', '.1000000000000001'] == ['', '.1']
      "test_dict_completion"
    ];

  meta = {
    changelog = "https://github.com/davidhalter/jedi/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Autocompletion tool for Python that can be used for text editors";
    homepage = "https://github.com/davidhalter/jedi";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
