{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecc016c5b32fa5da813ec8d272941cfddf5f6bba9060c405a70285415cbf24c9";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
