{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Flask-Cors";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62ebc5ad80dc21ca0ea9f57466c2c74e24a62274af890b391790c260eb7b754b";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
