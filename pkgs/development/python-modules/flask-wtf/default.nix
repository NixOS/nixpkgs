{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  flask,
  itsdangerous,
  wtforms,
  email-validator,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-wtf";
  version = "1.2.2";
  pyproject = true;

  src = fetchPypi {
    pname = "flask_wtf";
    inherit version;
    hash = "sha256-edLuHkNs9XC8y32RZTP6GHV6LxjCkKzP+rG5oLaEZms=";
  };

  build-system = [
    hatchling
    setuptools
  ];

  dependencies = [
    flask
    itsdangerous
    wtforms
  ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_wtf" ];

  meta = {
    description = "Simple integration of Flask and WTForms";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mic92
      anthonyroussel
    ];
    homepage = "https://github.com/pallets-eco/flask-wtf/";
    changelog = "https://github.com/pallets-eco/flask-wtf/releases/tag/v${version}";
  };
}
