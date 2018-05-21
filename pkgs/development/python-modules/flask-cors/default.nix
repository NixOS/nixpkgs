{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Flask-Cors";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bec996f0603a0693c0ea63c8126e5f8e966bb679cf82e6104b254e9c7f3a7d08";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
