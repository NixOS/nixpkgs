{
  lib,
<<<<<<< HEAD
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
=======
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  annotated-types,
  pydantic-core,
  typing-extensions,
  typing-inspection,

  # tests
  cloudpickle,
  email-validator,
  dirty-equals,
  jsonschema,
  pytestCheckHook,
<<<<<<< HEAD
  pytest-mock,
  pytest-run-parallel,
=======
  pytest-codspeed,
  pytest-mock,
  pytest-run-parallel,
  eval-type-backport,
  rich,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pydantic";
<<<<<<< HEAD
  version = "2.12.4";
  pyproject = true;

=======
  version = "2.11.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-CHJahAgs+vQQzhIZjP+6suvbmRrGZI0H5UxoXg4I90o=";
  };

  patches = lib.optionals (lib.versionAtLeast python.version "3.14.1") [
    # Fix build with python 3.14.1
    (fetchpatch {
      url = "https://github.com/pydantic/pydantic/commit/53cb5f830207dd417d20e0e55aab2e6764f0d6fc.patch";
      hash = "sha256-Y1Ob1Ei0rrw0ua+0F5L2iE2r2RdpI9DI2xuiu9pLr5Y=";
    })
  ];

=======
    hash = "sha256-5EQwbAqRExApJvVUJ1C6fsEC1/rEI6/bQEQkStqgf/Q=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    sed -i "/--benchmark/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    annotated-types
    pydantic-core
    typing-extensions
    typing-inspection
  ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    cloudpickle
    dirty-equals
    jsonschema
<<<<<<< HEAD
    pytest-mock
    pytest-run-parallel
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;
=======
    pytest-codspeed
    pytest-mock
    pytest-run-parallel
    pytestCheckHook
    rich
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies)
  ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTestPaths = [
    "tests/benchmarks"

    # avoid cyclic dependency
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

<<<<<<< HEAD
  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
=======
  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
