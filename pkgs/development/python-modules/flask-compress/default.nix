{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,
  setuptools,
  setuptools-scm,
  flask,
  brotli,
  brotlicffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "1.14";
  pname = "Flask-Compress";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "colour-science";
    repo = "flask-compress";
    rev = "refs/tags/v${version}";
    hash = "sha256-eP6i4h+O4vkjlhfy3kyB+PY7iHVzOnRBRD8lj5yHehU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    flask
  ] ++ lib.optionals (!isPyPy) [ brotli ] ++ lib.optionals isPyPy [ brotlicffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_compress" ];

  meta = with lib; {
    description = "Compress responses in your Flask app with gzip, deflate or brotli";
    homepage = "https://github.com/colour-science/flask-compress";
    changelog = "https://github.com/colour-science/flask-compress/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
