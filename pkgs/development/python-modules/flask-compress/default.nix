{ stdenv, fetchPypi, buildPythonPackage, flask
, brotli
}:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "Flask-Compress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d551211eca86e684c170491c857692b6c4c94a147ab6b41995decac8ee63567";
  };

  propagatedBuildInputs = [ flask brotli ];

  meta = with stdenv.lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = "https://libwilliam.github.io/flask-compress/";
    license = licenses.mit;
  };
}
