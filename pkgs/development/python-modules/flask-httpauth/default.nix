{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "006hsjmiv8r9ygpzch308x00a7vnwh5w9v5r3q1lk6h3fm1qw0ly";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ geistesk ];
  };
}
