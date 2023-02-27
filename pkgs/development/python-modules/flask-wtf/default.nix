{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, flask
, itsdangerous
, wtforms
, email-validator
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-wtf";
  version = "1.1.1";

  src = fetchPypi {
    pname = "Flask-WTF";
    inherit version;
    hash = "sha256-QcQkTprmJtY77UKuR4W5Bme4hbFTXVpAleH2MGDRKqk=";
  };

  propagatedBuildInputs = [
    flask
    itsdangerous
    wtforms
  ];

  passthru.optional-dependencies = {
    email = [ email-validator ];
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 anthonyroussel ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
