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
    pname = "pyicumessageformat";
    inherit version;
    hash = "sha256-s+l8DtEMKxA/DzpwGqZSlwDqCrZuDzsj3I5K7hgfyEA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyicumessageformat" ];

  meta = with lib; {
    description = "Unopinionated Python3 parser for ICU MessageFormat";
    homepage = "https://github.com/SirStendec/pyicumessageformat/";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
