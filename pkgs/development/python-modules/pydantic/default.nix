{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  pytest-mock,
  pytest-run-parallel,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-CHJahAgs+vQQzhIZjP+6suvbmRrGZI0H5UxoXg4I90o=";
  };

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
    pytest-mock
    pytest-run-parallel
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "tests/benchmarks"

    # avoid cyclic dependency
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
