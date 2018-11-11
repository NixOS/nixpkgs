{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e90bf225fdf163d11b84b59fb17594d0580a16b97ab4e1146b1fb2737c1cfec";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
