{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyicumessageformat";
  version = "1.0.0";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s+l8DtEMKxA/DzpwGqZSlwDqCrZuDzsj3I5K7hgfyEA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyicumessageformat" ];

  meta = with lib; {
    description = "Unopinionated Python3 parser for ICU MessageFormat";
    homepage = "https://github.com/SirStendec/pyicumessageformat/";
    # Based on master, as upstream doesn't tag their releases on GitHub anymore
    changelog = "https://github.com/SirStendec/pyicumessageformat/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
