{ lib, fetchPypi, buildPythonPackage, flask
, brotli
}:

buildPythonPackage rec {
  version = "1.9.0";
  pname = "Flask-Compress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d93edd8fc02ae74b73c3df10a8e7ee26dee489c65dedce0b3a1d2ce05ac3d1be";
  };

  propagatedBuildInputs = [ flask brotli ];

  meta = with lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = "https://libwilliam.github.io/flask-compress/";
    license = licenses.mit;
  };
}
