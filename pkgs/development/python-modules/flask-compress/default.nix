{ stdenv, fetchPypi, buildPythonPackage, flask
, brotli
}:

buildPythonPackage rec {
  version = "1.8.0";
  pname = "Flask-Compress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c132590e7c948877a96d675c13cbfa64edec0faafa2381678dea6f36aa49a552";
  };

  propagatedBuildInputs = [ flask brotli ];

  meta = with stdenv.lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = "https://libwilliam.github.io/flask-compress/";
    license = licenses.mit;
  };
}
