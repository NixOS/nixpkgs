{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  qt6,
  qtpy,
  pyqt6,
  mesa,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "echo";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "echo";
    tag = "v${version}";
    sha256 = "sha256-o1AC4vY6FaEOE7YNyHRYXv4z02tR3O4q5pvWiVIVEb8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  dependencies = [
    qt6.qtconnectivity
    qt6.qtbase
    qt6.qttools
    pyqt6
    numpy
    qtpy
  ];

  doCheck = lib.meta.availableOn stdenv.hostPlatform mesa.llvmpipeHook;

  preCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  nativeCheckInputs = [
    mesa.llvmpipeHook
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "echo" ];

  meta = {
    homepage = "https://github.com/glue-viz/echo";
    description = "Callback Properties in Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
