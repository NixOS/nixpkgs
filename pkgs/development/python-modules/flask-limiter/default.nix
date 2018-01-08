{ stdenv, fetchPypi, buildPythonPackage, flask, limits }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "1.0.1";
  pname = "Flask-Limiter";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f0diannnc6rc0ngsh222lws3qf89wxm0aschaxxvwjvybf9iklc";
  };

  propagatedBuildInputs = [ flask limits ];

  meta = with stdenv.lib; {
    description = "Rate limiting for flask applications";
    homepage = https://flask-limiter.readthedocs.org/;
    license = licenses.mit;
  };
}
