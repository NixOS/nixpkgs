{ lib, fetchPypi, buildPythonPackage, flask, limits }:

buildPythonPackage rec {
  pname = "Flask-Limiter";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "021279c905a1e24f181377ab3be711be7541734b494f4e6db2b8edeba7601e48";
  };

  propagatedBuildInputs = [ flask limits ];

  meta = with lib; {
    description = "Rate limiting for flask applications";
    homepage = "https://flask-limiter.readthedocs.org/";
    license = licenses.mit;
  };
}
