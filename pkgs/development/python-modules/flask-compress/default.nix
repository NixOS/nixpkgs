{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPyPy,
  setuptools,
  setuptools-scm,
  backports-zstd,
  flask,
  flask-caching,
  zstandard,
  brotli,
  brotlicffi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "1.24";
  pname = "flask-compress";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colour-science";
    repo = "flask-compress";
    tag = "v${version}";
    hash = "sha256-JbPBu8FWp/HnYbA2vTKiy2gopS5U0JNDV7ucTAYrLVY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    backports-zstd
    flask
  ]
  ++ lib.optionals (!isPyPy) [ brotli ]
  ++ lib.optionals isPyPy [ brotlicffi ];

  nativeCheckInputs = [
    pytestCheckHook
    flask-caching
  ];

  pythonImportsCheck = [ "flask_compress" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm[toml]<8" "setuptools_scm"
  '';

  meta = {
    description = "Compress responses in your Flask app with gzip, deflate or brotli";
    homepage = "https://github.com/colour-science/flask-compress";
    changelog = "https://github.com/colour-science/flask-compress/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
