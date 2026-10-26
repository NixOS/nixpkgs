{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyicumessageformat";
  version = "1.0.0";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-s+l8DtEMKxA/DzpwGqZSlwDqCrZuDzsj3I5K7hgfyEA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyicumessageformat" ];

  meta = {
    description = "Unopinionated Python3 parser for ICU MessageFormat";
    homepage = "https://github.com/SirStendec/pyicumessageformat/";
    # Based on master, as upstream doesn't tag their releases on GitHub anymore
    changelog = "https://github.com/SirStendec/pyicumessageformat/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
