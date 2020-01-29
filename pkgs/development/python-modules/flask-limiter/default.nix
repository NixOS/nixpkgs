{ stdenv, fetchPypi, buildPythonPackage, flask, limits }:

buildPythonPackage rec {
  pname = "Flask-Limiter";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "905c35cd87bf60c92fd87922ae23fe27aa5fb31980bab31fc00807adee9f5a55";
  };

  propagatedBuildInputs = [ flask limits ];

  meta = with stdenv.lib; {
    description = "Rate limiting for flask applications";
    homepage = https://flask-limiter.readthedocs.org/;
    license = licenses.mit;
  };
}
