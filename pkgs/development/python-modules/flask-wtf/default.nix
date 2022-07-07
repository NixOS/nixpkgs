{ lib
, fetchPypi
, buildPythonPackage
, flask
, itsdangerous
, wtforms
, email-validator
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-wtf";
  version = "1.0.1";

  src = fetchPypi {
    pname = "Flask-WTF";
    inherit version;
    sha256 = "34fe5c6fee0f69b50e30f81a3b7ea16aa1492a771fe9ad0974d164610c09a6c9";
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
    maintainers = [ maintainers.mic92 ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
