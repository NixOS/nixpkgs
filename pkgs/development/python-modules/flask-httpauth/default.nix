{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fb1kr1iw6inkwfv160rpjx54vv1q9b90psdyyghyy1f6dhvgy3f";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ geistesk ];
  };
}
