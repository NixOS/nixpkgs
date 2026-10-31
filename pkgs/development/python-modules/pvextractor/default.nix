{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  astropy,
  qtpy,
  pyqt6,
  pyqt-builder,
  setuptools,
  setuptools-scm,
  scipy,
  matplotlib,
  spectral-cube,
  pytestCheckHook,
  pytest-astropy,
}:

buildPythonPackage rec {
  pname = "pvextractor";
  version = "0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = "pvextractor";
    tag = "v${version}";
    hash = "sha256-jhzu1PDLNWel1/s/Y+5h0mIIXV1DpQC7NV4kawG0dRU=";
  };

  buildInputs = [ pyqt-builder ];
  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];
  propagatedBuildInputs = [
    astropy
    scipy
    matplotlib
    pyqt6
    qtpy
    spectral-cube
  ];

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-astropy
  ];

  pythonImportsCheck = [ "pvextractor" ];

  meta = {
    homepage = "http://pvextractor.readthedocs.io";
    description = "Position-velocity diagram extractor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
