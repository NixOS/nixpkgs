{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-httpauth";
  version = "4.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "Flask-HTTPAuth";
    version = version;
    hash = "sha256-iEmbIvE1OJN0PDzWjyylYcStnvdc1rzH9iEWHNDoB0Q=";
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
    maintainers = [ ];
  };
}
