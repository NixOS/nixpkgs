{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "10.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JUiPhmPdFSiuH1T5SsHqUa4ltNUxU5uLxwf+0YTRaEU=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aniso8601" ];

  meta = {
    description = "Python Parser for ISO 8601 strings";
    homepage = "https://bitbucket.org/nielsenb/aniso8601";
    changelog = "https://bitbucket.org/nielsenb/aniso8601/src/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
