{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatchling,
  annotated-types,
  pydantic-core_2_46_5,
  typing-extensions,
  typing-inspection,
  cloudpickle,
  dirty-equals,
  email-validator,
  hypothesis,
  inline-snapshot,
  jsonschema,
  pytest-mock,
  pytest-run-parallel,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.13.5";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UanF97L45jbwTGytpgXZtqO/E0j9+UWj2IabGbug7gg=";
  };

  # pytest 9.1 compatibility fixes from upstream Pydantic commit f257d015.
  patches = [ ./pytest-9.1-compat.patch ];

  postPatch = ''
    sed -i "/--benchmark/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    annotated-types
    pydantic-core_2_46_5
    typing-extensions
    typing-inspection
  ];

  optional-dependencies.email = [ email-validator ];

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
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "tests/benchmarks"

    # Avoid cyclic dependency.
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
