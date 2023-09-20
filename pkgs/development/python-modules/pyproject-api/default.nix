{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build time
, hatchling
, hatch-vcs

# runtime
, packaging
, toml
, tomli

# docs
, sphinxHook
, furo
, sphinx-autodoc-typehints

# tests
, pytest-mock
, pytestCheckHook
, setuptools
, virtualenv
, wheel
}:

buildPythonPackage rec {
  pname = "pyproject-api";
  version = "1.5.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pyproject-api";
    rev = "refs/tags/${version}";
    hash = "sha256-HX+5BypfEOfQ3vg3vha0QCVrEarjMu/Q8id+xgmWGfA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs

    # docs
    sphinxHook
    furo
    sphinx-autodoc-typehints
  ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    setuptools
    virtualenv
    wheel
  ];

  disabledTests = [
    # requires eol python2 interpreter
    "test_can_build_on_python_2"
  ];

  pythonImportsCheck = [
    "pyproject_api"
  ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/pyproject-api/releases/tag/${version}";
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "https://github.com/tox-dev/pyproject-api";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
