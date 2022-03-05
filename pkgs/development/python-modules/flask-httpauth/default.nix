{ lib, python, buildPythonPackage, fetchPypi, pytestCheckHook, flask }:

buildPythonPackage rec {
  pname = "flask-httpauth";
  version = "4.5.0";

  disabled = python.pythonOlder "3";

  src = fetchPypi {
    pname = "Flask-HTTPAuth";
    version = version;
    sha256 = "0ada63rkcvwkakjyx4ay98fjzwx5h55br12ys40ghkc5lbyl0l1r";
  };

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ flask ];

  pythonImportsCheck = [ "flask_httpauth" ];

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
