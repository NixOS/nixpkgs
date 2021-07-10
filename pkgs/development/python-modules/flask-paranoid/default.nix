{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, flask
, pytest
, pytest-runner
}:

buildPythonPackage rec {
  pname = "Flask-Paranoid";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ou6SV2QuAlTxFXikqlShpyUWemQc+gh5Mw1HfsNwx0k=";
  };

  propagatedBuildInputs = [
    flask
  ];

  checkInputs = [
    pytest
    pytest-runner
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/miguelgrinberg/flask-paranoid/";
    description = "Simple user session protection";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
