{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, flask
, brotli
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.11";
  pname = "Flask-Compress";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9WnzLERtayXKjjR9UAOgUxgR73MmeABbADb8HJ6xwhw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    flask
    brotli
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flask_compress"
  ];

  meta = with lib; {
    description = "Compress responses in your Flask app with gzip";
    homepage = "https://github.com/colour-science/flask-compress";
    changelog = "https://github.com/colour-science/flask-compress/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
  };
}
