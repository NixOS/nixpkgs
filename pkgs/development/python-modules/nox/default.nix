{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  attrs,
  argcomplete,
  colorlog,
  dependency-groups,
  jinja2,
  packaging,
  tomli,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  tox,
  uv,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "nox";
  version = "2025.05.01";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = "nox";
    tag = version;
    hash = "sha256-qH8oh7tmiJkXOobyDZMRZ62w2sRHJF8sh4PX+6s7M70=";
  };

  build-system = [ hatchling ];

  dependencies = [
    argcomplete
    attrs
    colorlog
    dependency-groups
    packaging
    virtualenv
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  optional-dependencies = {
    tox_to_nox = [
      jinja2
      tox
    ];
    uv = [ uv ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "nox" ];

  disabledTests = [
    # Assertion errors
    "test_uv"
    # Test requires network access
    "test_noxfile_script_mode_url_req"
    # Don't test CLi mode
    "test_noxfile_script_mode"
  ];

  disabledTestPaths = [
    # AttributeError: module 'tox.config' has...
    "tests/test_tox_to_nox.py"
  ];

  meta = {
    description = "Flexible test automation for Python";
    homepage = "https://nox.thea.codes/";
    changelog = "https://github.com/wntrblm/nox/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      doronbehar
      fab
    ];
  };
}
