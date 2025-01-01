{
  lib,
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
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "echo";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IKd5n8+U6+0dgV4PbLcPaormXCX4srGcXmvYSrnCt60=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    qt6.wrapQtAppsHook
  ];

  buildInputs = lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  propagatedBuildInputs = [
    qt6.qtconnectivity
    qt6.qtbase
    qt6.qttools
    pyqt6
    numpy
    qtpy
  ];

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "echo" ];

  meta = with lib; {
    homepage = "https://github.com/glue-viz/echo";
    description = "Callback Properties in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ ifurther ];
  };
}
