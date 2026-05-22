{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # tests
  hypothesis,
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "harfile";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NOLZ7zQQHXaVZr/6s8Qg4Ud3YXQwi+0aA27Y22AMq94=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    hypothesis
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [ "harfile" ];

  meta = {
    description = "Writer for HTTP Archive (HAR) files";
    homepage = "https://github.com/schemathesis/harfile";
    changelog = "https://github.com/schemathesis/harfile/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tembleking ];
  };
})
