{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build time
, hatchling
, hatch-vcs
<<<<<<< HEAD
=======
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, virtualenv
, wheel
}:

buildPythonPackage rec {
  pname = "pyproject-api";
<<<<<<< HEAD
  version = "1.5.4";
=======
  version = "1.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pyproject-api";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-HX+5BypfEOfQ3vg3vha0QCVrEarjMu/Q8id+xgmWGfA=";
=======
    hash = "sha256-VO+huA9i7uMpCVaWHC29XlfestSu+N9vWWHteY21uqs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "doc"
  ];

<<<<<<< HEAD
  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;
=======
  SETUPTOOLS_SCM_PRETEND_VERSION = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    hatchling
    hatch-vcs
<<<<<<< HEAD
=======
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
