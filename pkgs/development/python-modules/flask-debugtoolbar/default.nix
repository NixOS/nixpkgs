{ lib
, buildPythonPackage
, flask
, blinker
, itsdangerous
, werkzeug
, markupsafe
, fetchPypi
, setuptools
}:

let
  pname = "Flask-DebugToolbar";
  version = "0.13.1";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DCaqATqYE7iIaFe/DsJNKKtJQRSiZLrwbJUcrcTdDa4=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    flask
    blinker
    itsdangerous
    werkzeug
    markupsafe
  ];

  meta = with lib; {
    description = "A toolbar overlay for debugging Flask applications";
    homepage = "https://github.com/pallets-eco/flask-debugtoolbar";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jfvillablanca ];
  };
}
