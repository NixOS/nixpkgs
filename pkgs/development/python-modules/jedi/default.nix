{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  parso,

  # tests
  attrs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.19.1-unstable-2024-10-17";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "30adf43a8929ade8a9e0abee6921a5043c962215";
    hash = "sha256-ytpNKpbaisdd+BXsZBpJV09JRCrX1JcKAelDpIW0bR8=";
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
    [
      # sensitive to platform, causes false negatives on darwin
      "test_import"
    ]
    ++ lib.optionals (stdenv.targetPlatform.useLLVM or false) [
      # InvalidPythonEnvironment: The python binary is potentially unsafe.
      "test_create_environment_executable"
      # AssertionError: assert ['', '.1000000000000001'] == ['', '.1']
      "test_dict_keys_completions"
      # AssertionError: assert ['', '.1000000000000001'] == ['', '.1']
      "test_dict_completion"
    ];

  meta = with lib; {
    description = "Autocompletion tool for Python that can be used for text editors";
    homepage = "https://github.com/davidhalter/jedi";
    changelog = "https://github.com/davidhalter/jedi/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
