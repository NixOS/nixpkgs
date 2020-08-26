{ stdenv, fetchPypi, buildPythonPackage, flask
, brotli
}:

buildPythonPackage rec {
  version = "1.5.0";
  pname = "Flask-Compress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f367b2b46003dd62be34f7fb1379938032656dca56377a9bc90e7188e4289a7c";
  };

  propagatedBuildInputs = [ flask brotli ];

  meta = with stdenv.lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = "https://libwilliam.github.io/flask-compress/";
    license = licenses.mit;
  };
}
