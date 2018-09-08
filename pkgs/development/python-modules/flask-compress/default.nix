{ stdenv, fetchPypi, buildPythonPackage, flask }:

buildPythonPackage rec {
  version = "1.4.0";
  pname = "Flask-Compress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cxdbdiyxkspg7vkchfmaqr7c6q79gwvakna3fjcc6nivps971j6";
  };

  propagatedBuildInputs = [ flask ];

  meta = with stdenv.lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = https://libwilliam.github.io/flask-compress/;
    license = licenses.mit;
  };
}
