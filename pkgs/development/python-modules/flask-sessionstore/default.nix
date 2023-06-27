{ lib
, fetchPypi
, buildPythonPackage
, flask
, nose
}:

buildPythonPackage rec {
  pname = "flask-sessionstore";
  version = "0.4.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Sessionstore";
    inherit version;
    hash = "sha256-AQ3jWrnw2UI8L3nFEx4AhDwGP4R8Tr7iBMsDS5jLQPQ=";
  };

  propagatedBuildInputs = [ flask ];

  pythonImportsCheck = [ "flask_sessionstore" ];

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests -s
  '';

  meta = with lib; {
    description = "Session Storage Backends for Flask";
    homepage = "https://github.com/mcrowson/flask-sessionstore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Flakebi ];
  };
}
