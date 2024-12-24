{
  lib,
  argcomplete,
  buildPythonPackage,
  colorlog,
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
  version = "2024.10.09";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = "nox";
    rev = "refs/tags/${version}";
    hash = "sha256-GdNz34A8IKwPG/270sY5t3SoggGCZMWfDq/Wyhk0ez8=";
  };

  patches = [
    # Backport of https://github.com/wntrblm/nox/pull/903, which can be removed on next release
    ./fix-broken-mock-on-cpython-3.12.8.patch
  ];

  build-system = [ hatchling ];

  dependencies =
    [
      argcomplete
      colorlog
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
  ];

  disabledTestPaths = [
    # AttributeError: module 'tox.config' has...
    "tests/test_tox_to_nox.py"
  ];

  meta = with lib; {
    description = "Flexible test automation for Python";
    homepage = "https://nox.thea.codes/";
    changelog = "https://github.com/wntrblm/nox/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      doronbehar
      fab
    ];
  };
}
