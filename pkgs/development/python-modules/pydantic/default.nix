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
  hypothesis,
  inline-snapshot,
  jsonschema,
  pytestCheckHook,
  pytest-mock,
  pytest-run-parallel,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic";
  version = "2.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q5dvfgbbYw3QeB1nY+eUIBoVsUpxgLKE8jTX6CJV+Zs=";
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
    hypothesis
    (inline-snapshot.overridePythonAttrs { doCheck = false; })
    jsonschema
    pytest-mock
    pytest-run-parallel
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    "tests/benchmarks"
    "tests/pydantic_core/benchmarks"

    # avoid cyclic dependency
    "tests/pydantic_core/test_docstrings.py"
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
  };

  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${finalAttrs.src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      wd15
    ];
  };
})
