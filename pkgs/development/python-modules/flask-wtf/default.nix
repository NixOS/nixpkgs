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
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "flask_wtf";
    inherit version;
    hash = "sha256-i7Jp65u0a4fnyCM9fn3r3x+LdL+QzBeJmIwps3qXtpU=";
  };

  nativeBuildInputs = [
    hatchling
    setuptools
  ];

  propagatedBuildInputs = [
    flask
    itsdangerous
    wtforms
  ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Simple integration of Flask and WTForms";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      mic92
      anthonyroussel
    ];
    homepage = "https://github.com/lepture/flask-wtf/";
    changelog = "https://github.com/wtforms/flask-wtf/releases/tag/v${version}";
  };
}
