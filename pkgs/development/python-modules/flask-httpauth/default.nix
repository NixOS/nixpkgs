{ lib, python, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05j1mckwhgicrlj4j7ni2rhcf9w4i7phll06jbjjyvs3rj1l4q1f";
  };

  propagatedBuildInputs = [ flask ];

  pythonImportsCheck = [ "flask_httpauth" ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
