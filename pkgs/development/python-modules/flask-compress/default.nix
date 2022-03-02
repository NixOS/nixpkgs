{ lib, fetchPypi, buildPythonPackage, flask
, brotli
}:

buildPythonPackage rec {
  version = "1.11";
  pname = "Flask-Compress";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9WnzLERtayXKjjR9UAOgUxgR73MmeABbADb8HJ6xwhw=";
  };

  postPatch = ''
    sed -i -e 's/use_scm_version=.*/version="${version}",/' setup.py
  '';

  propagatedBuildInputs = [ flask brotli ];

  meta = with lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = "https://libwilliam.github.io/flask-compress/";
    license = licenses.mit;
  };
}
