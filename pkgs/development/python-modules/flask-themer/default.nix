{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "flask-themer";
  version = "2.0.0";
  pyproject = true;

  # Pypi tarball doesn't contain tests/
  src = fetchFromGitHub {
    owner = "TkTech";
    repo = "flask-themer";
    rev = "v${version}";
    sha256 = "sha256-2Zw+gKKN0kfjYuruuLQ+3dIFF0X07DTy0Ypc22Ih66w=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "flask_themer" ];

  meta = with lib; {
    description = "Simple theming support for Flask apps.";
    homepage = "https://github.com/TkTech/flask-themer";
    license = licenses.mit;
    maintainers = with maintainers; [
      imsofi
      erictapen
    ];
  };
}
