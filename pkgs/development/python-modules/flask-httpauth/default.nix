{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e028e4375039a49031eb9ecc40be4761f0540476040f6eff329a31dabd4d000";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ geistesk ];
  };
}
