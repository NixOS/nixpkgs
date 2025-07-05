{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build time
  hatchling,
  hatch-vcs,

  # runtime
  packaging,
  tomli,

  # docs
  sphinxHook,
  furo,
  sphinx-autodoc-typehints,

  # tests
  pytest-mock,
  pytestCheckHook,
  setuptools,
  virtualenv,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyproject-api";
  version = "1.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pyproject-api";
    tag = version;
    hash = "sha256-Bf/FG5BNKbV3lfebEHFJ3cy80L1mWTYLXJfqPUzeNXc=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    hatchling
    hatch-vcs

    # docs
    sphinxHook
    furo
    sphinx-autodoc-typehints
  ];

  propagatedBuildInputs = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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
    # different formatting for version specifier
    "test_setuptools_prepare_metadata_for_build_wheel"
  ];

  pythonImportsCheck = [ "pyproject_api" ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/pyproject-api/releases/tag/${version}";
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "https://github.com/tox-dev/pyproject-api";
    license = licenses.mit;
    maintainers = [ ];
  };
}
