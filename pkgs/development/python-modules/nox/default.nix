{
  lib,
  argcomplete,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  hatchling,
  importlib-metadata,
  jinja2,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tox,
  typing-extensions,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "nox";
  version = "2024.04.15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PagZR2IdS1gS/ukl4b0Al9sdEsFnFwP8oy0eOGKJHMs=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs =
    [
      argcomplete
      colorlog
      packaging
      virtualenv
    ]
    ++ lib.optionals (pythonOlder "3.8") [
      typing-extensions
      importlib-metadata
    ];

  nativeCheckInputs = [
    jinja2
    tox
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nox" ];

  disabledTests = [
    # our conda is not available on 3.11
    "test__create_venv_options"
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
