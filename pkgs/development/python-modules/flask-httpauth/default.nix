{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "Flask-HTTPAuth";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z3ad8sm24xl2lazdia92br1a2nigqwaf1lfsa77j5pz6gf2xmj7";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ geistesk ];
  };
}
