{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c7e49e53ce7dc14e66fe39b9334e4b7ceb8d0b99a6ba1c3562bb528ef9da84a";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
