{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, nose
, webargs
}:

buildPythonPackage rec {
  pname = "Flask-Classful";
  version = "0.15.0-b1";

  src = fetchFromGitHub {
    owner = "teracyhq";
    repo = "flask-classful";
    rev = "v${version}";
    sha256 = "+PIfqn//70YDDJZ92VD/QxuTLigI/o2AUQJ0SRLhZxc=";
  };

  propagatedBuildInputs = [
    flask
  ];

  checkInputs = [
    nose
    webargs
  ];

  checkPhase = ''
    runHook preCheck

    nosetests

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "http://flask-classful.teracy.org/";
    description = "Class based views for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
