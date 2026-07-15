{
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  jsonschema,
  lib,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hypothesis-jsonschema";
  version = "0.23.1";
  pyproject = true;
  __structuredAttrs = true;

  # no tags on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9KwDICQ0KkFJoQJTmE9aVza4Kz/ir7CIjzg0oxFT8hU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hypothesis
    jsonschema
  ];

  pythonImportsCheck = [ "hypothesis_jsonschema" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTestPaths = [
    # imports gen_schemas.py, which is missing from sdist
    "tests/test_canonicalise.py"
    "tests/test_from_schema.py"
    # reads CHANGELOD.md, which is missing from sdist
    "tests/test_version.py"
  ];

  meta = {
    changelog = "https://github.com/Zac-HD/hypothesis-jsonschema/blob/master/CHANGELOG.md";
    description = "Generate test data from JSON schemata with Hypothesis";
    homepage = "https://github.com/Zac-HD/hypothesis-jsonschema";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
