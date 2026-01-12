{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
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

  disabledTests = [
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

  disabledTestPaths = lib.optionals (pythonAtLeast "3.14") [
    # Jedi.api.environment.InvalidPythonEnvironment: The python binary is potentially unsafe
    "test/test_inference/test_sys_path.py::test_venv_and_pths"
    "test/test_api/test_environment.py::test_create_environment_venv_path"
    "test/test_api/test_environment.py::test_create_environment_executable"
    # can't find system env nor venv
    "test/test_api/test_environment.py::test_find_system_environments"
    "test/test_api/test_environment.py::test_scanning_venvs"
    # https://github.com/davidhalter/jedi/issues/2064
    "test/test_api/test_interpreter.py::test_string_annotation"
    # type repr mismatch: Union[Type, int] vs Type | int
    "test/test_inference/test_mixed.py::test_compiled_signature_annotation_string"
  ];

  meta = {
    description = "Autocompletion tool for Python that can be used for text editors";
    homepage = "https://github.com/davidhalter/jedi";
    changelog = "https://github.com/davidhalter/jedi/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
