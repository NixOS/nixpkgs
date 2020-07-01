{ stdenv, fetchPypi, buildPythonPackage, flask, limits }:

buildPythonPackage rec {
  pname = "Flask-Limiter";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08d6d7534a847c532fd36d0df978f93908d8616813085941c862bbcfcf6811aa";
  };

  propagatedBuildInputs = [ flask limits ];

  meta = with stdenv.lib; {
    description = "Rate limiting for flask applications";
    homepage = "https://flask-limiter.readthedocs.org/";
    license = licenses.mit;
  };
}
