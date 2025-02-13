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
  version = "0.19.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
    hash = "sha256-2nDQJS6LIaq91PG3Av85OMFfs1ZwId00K/kvog3PGXE=";
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
