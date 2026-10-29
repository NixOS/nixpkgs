{
  lib,
  buildPythonPackage,
  fetchPypi,
  jsonschema,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsonmerge";
  version = "1.9.2";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xDdX4BgLDhm3rkwTCtQqB8xYDDGRL2H0gj6Ory+jlKM=";
  };

  build-system = [ setuptools ];

  dependencies = [ jsonschema ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Merge a series of JSON documents";
    homepage = "https://github.com/avian2/jsonmerge";
    changelog = "https://github.com/avian2/jsonmerge/blob/jsonmerge-${finalAttrs.version}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
