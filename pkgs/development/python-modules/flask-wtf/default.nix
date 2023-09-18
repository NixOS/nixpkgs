{ lib
, fetchPypi
, buildPythonPackage
, flask
, itsdangerous
, wtforms
, email-validator
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "flask-wtf";
  version = "1.1.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "Flask-WTF";
    inherit version;
    hash = "sha256-QcQkTprmJtY77UKuR4W5Bme4hbFTXVpAleH2MGDRKqk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    flask
    itsdangerous
    wtforms
  ];

  passthru.optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 anthonyroussel ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
