{
  lib,
  argcomplete,
  attrs,
  buildPythonPackage,
  colorlog,
  dependency-groups,
  fetchFromGitHub,
  hatchling,
  jinja2,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tomli,
  tox,
  uv,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "nox";
  version = "2025.05.01";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "nox" ];

  disabledTests = [
    # our conda is not available on 3.11
    "test__create_venv_options"
    # Assertion errors
    "test_uv"
    # calls to naked python
    "test_noxfile_script_mode"
    "test_noxfile_script_mode_url_req"
  ];

  disabledTestPaths = [
    # AttributeError: module 'tox.config' has...
    "tests/test_tox_to_nox.py"
  ];

  meta = with lib; {
    description = "Flexible test automation for Python";
    homepage = "https://nox.thea.codes/";
    changelog = "https://github.com/wntrblm/nox/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      doronbehar
      fab
    ];
  };
}
