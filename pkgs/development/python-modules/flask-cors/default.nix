{ stdenv, fetchPypi, buildPythonPackage
, nose, flask, six }:

buildPythonPackage rec {
  pname = "Flask-Cors";
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05id72xwvhni23yasdvpdd8vsf3v4j6gzbqqff2g04j6xcih85vj";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ flask six ];

  meta = with stdenv.lib; {
    description = "A Flask extension adding a decorator for CORS support";
    homepage = https://github.com/corydolphin/flask-cors;
    license = with licenses; [ mit ];
  };
}
