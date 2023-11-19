{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, astropy
, qtpy
, pyqt6
, pyqt-builder
, setuptools
, setuptools-scm
, scipy
, matplotlib
, spectral-cube
, pytestCheckHook
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "pvextractor";
  version = "0.3";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HYus2Gk3hzKq+3lJLOJQ+EE6LeO+DrvqLK3NpqrUYeI=";
  };

  buildInputs = [ pyqt-builder ];
  nativeBuildInputs = [ setuptools setuptools-scm ];
  propagatedBuildInputs = [
    astropy
    scipy
    matplotlib
    pyqt6
    qtpy
    spectral-cube
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-astropy
  ];

  pythonImportsCheck = [ "pvextractor" ];

  meta = with lib; {
    homepage = "http://pvextractor.readthedocs.io";
    description = "Position-velocity diagram extractor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ifurther ];
  };
}
