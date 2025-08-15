{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  libxcrypt,
  numpy,
  qt5,
  qtpy,
  pyqt5,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "echo";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "echo";
    tag = "v${version}";
    sha256 = "sha256-RlTscoStJQ0vjrrk14xHRsMZOJt8eJSqinc4rY/lW4k=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    qt5.wrapQtAppsHook
  ];

  buildInputs = lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  propagatedBuildInputs = [
    qt5.qtconnectivity
    qt5.qtbase
    qt5.qttools
    pyqt5
    numpy
    qtpy
  ];

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [
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
