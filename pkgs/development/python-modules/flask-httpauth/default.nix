{ lib, python, buildPythonPackage, fetchPypi, pytestCheckHook, flask }:

buildPythonPackage rec {
  pname = "flask-httpauth";
  version = "4.7.0";

  disabled = python.pythonOlder "3";

  src = fetchPypi {
    pname = "Flask-HTTPAuth";
    version = version;
    sha256 = "sha256-9xmee60g1baLPwtivd/KdjfFUIfp0C9gWuJuDeR5/ZQ=";
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
