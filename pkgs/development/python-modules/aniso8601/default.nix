{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "10.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/x0PwjRmiMYsAVFUcTasMOMiiW7YrzFu92AsR9qUJs8=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aniso8601" ];

  meta = with lib; {
    description = "Python Parser for ISO 8601 strings";
    homepage = "https://bitbucket.org/nielsenb/aniso8601";
    changelog = "https://bitbucket.org/nielsenb/aniso8601/src/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
