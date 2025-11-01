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
  humanize,
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
  version = "2025.10.16";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = "nox";
    tag = version;
    hash = "sha256-oRVDGHw/0HkHLtzcSZL2Aj1uxuRS/ms66cBPDQjJ17I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    argcomplete
    attrs
    colorlog
    dependency-groups
    humanize
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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
