{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, flask
, blinker
, itsdangerous
, flask_principal
, passlib
, email_validator
, flask_wtf
, flask_login
, pytest
}:

buildPythonPackage rec {
  pname = "Flask-Security-Too";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "wpZ/zgjL4qHGrajqr8cXYm2Q8pbvp6F/hZwT9Gv+8eA=";
  };

  propagatedBuildInputs = [
    flask
    flask_login
    flask_principal
    flask_wtf
    email_validator
    itsdangerous
    passlib
    blinker
  ];

  doCheck = false;

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    homepage = "https://pypi.org/project/Flask-Security-Too/";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
