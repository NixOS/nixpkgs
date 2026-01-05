{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  flask,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flask-httpauth";
  version = "4.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-HTTPAuth";
    version = version;
    hash = "sha256-ZlaKBbxzlCxl8eIgGudGKVgW3ACe3YS0gsRMdY11CXo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ flask ];

  pythonImportsCheck = [ "flask_httpauth" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ flask.optional-dependencies.async;

  meta = {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    changelog = "https://github.com/miguelgrinberg/Flask-HTTPAuth/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
