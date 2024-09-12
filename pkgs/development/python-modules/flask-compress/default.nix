{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,
  setuptools,
  setuptools-scm,
  flask,
  zstandard,
  brotli,
  brotlicffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "1.15";
  pname = "flask-compress";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colour-science";
    repo = "flask-compress";
    rev = "refs/tags/v${version}";
    hash = "sha256-J7d/OIUsDWM6DoXS0P4EOE3k6txXKm6m4Yq/EJk6FRE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    flask
    zstandard
  ] ++ lib.optionals (!isPyPy) [ brotli ] ++ lib.optionals isPyPy [ brotlicffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flask_compress" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml]<8" "setuptools_scm"
  '';

  meta = {
    description = "Compress responses in your Flask app with gzip, deflate or brotli";
    homepage = "https://github.com/colour-science/flask-compress";
    changelog = "https://github.com/colour-science/flask-compress/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
