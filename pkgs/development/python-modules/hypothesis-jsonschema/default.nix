{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hypothesis,
  jsonschema,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage (finalAttrs: {
  pname = "hypothesis-jsonschema";
  version = "0.23.1";
  pyproject = true;

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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  # tox.ini has pytest coverage flags that require pytest-cov; remove it
  preCheck = ''
    rm tox.ini
  '';

  pytestFlags = [
    # some hypothesis-jsonschema tests depend on -Werror turning warnings into
    # errors. In the repo itself, this is set by tox.ini, which we removed above.
    "-Werror"
  ];

  disabledTestPaths = [
    # The pypi sdist does not include CHANGELOG.md or the schema json files
    # required by these tests.
    "tests/test_version.py"
    "tests/test_canonicalise.py"
    "tests/test_from_schema.py"
  ];

  pythonImportsCheck = [ "hypothesis_jsonschema" ];

  meta = {
    description = "Generate test data from JSON schemata with Hypothesis";
    homepage = "https://github.com/python-jsonschema/hypothesis-jsonschema";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.liamdevoe
    ];
  };
})
