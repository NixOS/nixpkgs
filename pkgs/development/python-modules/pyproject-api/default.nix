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
<<<<<<< HEAD
=======
  setuptools,
  virtualenv,
  wheel,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pyproject-api";
<<<<<<< HEAD
  version = "1.10.0";
  pyproject = true;
=======
  version = "1.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tox-dev";
    repo = "pyproject-api";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-fWlGGVjB43NPfBRFfOWqZUDQuqOdrFP7jsqq9xOfvaw=";
=======
    hash = "sha256-Bf/FG5BNKbV3lfebEHFJ3cy80L1mWTYLXJfqPUzeNXc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "doc"
  ];

<<<<<<< HEAD
  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeBuildInputs = [
=======
  nativeBuildInputs = [
    hatchling
    hatch-vcs

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # docs
    sphinxHook
    furo
    sphinx-autodoc-typehints
  ];

<<<<<<< HEAD
  dependencies = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
=======
  propagatedBuildInputs = [ packaging ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
<<<<<<< HEAD
=======
    setuptools
    virtualenv
    wheel
  ];

  disabledTests = [
    # requires eol python2 interpreter
    "test_can_build_on_python_2"
    # different formatting for version specifier
    "test_setuptools_prepare_metadata_for_build_wheel"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "pyproject_api" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/tox-dev/pyproject-api/releases/tag/${version}";
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "https://github.com/tox-dev/pyproject-api";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/tox-dev/pyproject-api/releases/tag/${version}";
    description = "API to interact with the python pyproject.toml based projects";
    homepage = "https://github.com/tox-dev/pyproject-api";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
