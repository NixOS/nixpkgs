{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hypothesis,
  jsonschema,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hypothesis-jsonschema";
  version = "0.23.1";
  pyproject = true;

  __structuredAttrs = true;

  # no git tags
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9KwDICQ0KkFJoQJTmE9aVza4Kz/ir7CIjzg0oxFT8hU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    hypothesis
    jsonschema
  ];

  doCheck = false; # sdist does not include everything to run the tests

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hypothesis_jsonschema"
  ];

  meta = {
    description = "Generate test data from JSON schemata with Hypothesis";
    homepage = "https://github.com/Zac-HD/hypothesis-jsonschema";
    license = lib.licenses.mpl20;
  };
})
