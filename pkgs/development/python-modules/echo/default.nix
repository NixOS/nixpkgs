{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  libxcrypt,
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
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "echo";
    tag = "v${version}";
    sha256 = "sha256-Uikzn9vbLctiZ6W0uA6hNvr7IB/FhCcHk+JxBW7yrA4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = lib.optionals (pythonOlder "3.9") [ libxcrypt ];

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

  meta = with lib; {
    homepage = "https://github.com/glue-viz/echo";
    description = "Callback Properties in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ ifurther ];
  };
}
