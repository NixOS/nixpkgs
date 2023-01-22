{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, flask
, brotli
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.13";
  pname = "Flask-Compress";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7pbxi/mwDy3rTjQGykoFCTqoDi7wV4Ulo7TTLs3/Ep0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    flask
    brotli
  ];

  nativeCheckInputs = [
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
