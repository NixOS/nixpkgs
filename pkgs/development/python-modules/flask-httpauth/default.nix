{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-httpauth";
  version = "4.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-HTTPAuth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KFG4rPhQMZfM/X0XJBOz6N1Ph560ALtla899JIPl7Ns=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ flask.optional-dependencies.async;

  pythonImportsCheck = [ "flask_httpauth" ];

  meta = {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    changelog = "https://github.com/miguelgrinberg/Flask-HTTPAuth/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
