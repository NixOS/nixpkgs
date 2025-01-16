{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
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

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "Simple integration of Flask and WTForms";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      mic92
      anthonyroussel
    ];
    homepage = "https://github.com/pallets-eco/flask-wtf/";
    changelog = "https://github.com/pallets-eco/flask-wtf/releases/tag/v${version}";
  };
}
