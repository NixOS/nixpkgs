{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v6gq4vjgyxi8q8lxawpdfhq01adb4bznnabp08ks5nzbwibz43y";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
