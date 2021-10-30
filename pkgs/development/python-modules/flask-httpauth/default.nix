{ lib, python, isPy3k, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "4.4.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fl1if91hg2c92b6sic7h2vhxxvb06ri7wflmwp0pfiwbaisgamw";
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
