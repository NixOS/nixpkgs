{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  jsonschema,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hypothesis-jsonschema";
  version = "0.23.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9KwDICQ0KkFJoQJTmE9aVza4Kz/ir7CIjzg0oxFT8hU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    hypothesis
    jsonschema
  ];

  # Tests require a `gen_schemas` helper module and a JSON Schema corpus that
  # are not shipped in the PyPI sdist.
  doCheck = false;

  pythonImportsCheck = [ "hypothesis_jsonschema" ];

  meta = {
    description = "Hypothesis strategies for JSON-Schema-based property testing";
    homepage = "https://github.com/python-jsonschema/hypothesis-jsonschema";
    changelog = "https://github.com/python-jsonschema/hypothesis-jsonschema/blob/master/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ tembleking ];
  };
}
