{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, dill
, astropy
, numpy
, pandas
, qt6
, pyqt6
, pyqt-builder
, qtconsole
, setuptools
, setuptools-scm
, scipy
, ipython
, ipykernel
, h5py
, matplotlib
, xlrd
, mpl-scatter-density
, pvextractor
, openpyxl
, echo
, pytest
, pytest-flakes
, pytest-cov
}:

buildPythonPackage rec {
  pname = "glueviz";
  version = "1.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "glue";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-nr84GJAGnpKzjZEFNsQujPysSQENwGxdNfPIYUCJkK4=";
  };

  buildInputs = [ pyqt-builder ];
  nativeBuildInputs = [ setuptools setuptools-scm qt6.wrapQtAppsHook ];
  propagatedBuildInputs = [
    astropy
    dill
    setuptools
    scipy
    numpy
    matplotlib
    pandas
    pyqt6
    qtconsole
    ipython
    ipykernel
    h5py
    xlrd
    mpl-scatter-density
    pvextractor
    openpyxl
    echo
  ];

  dontConfigure = true;

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [ pytest pytest-flakes pytest-cov ];

  pythonImportsCheck = [ "glue" ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://glueviz.org";
    description = "Linked Data Visualizations Across Multiple Files";
    license = licenses.bsd3; # https://github.com/glue-viz/glue/blob/main/LICENSE
    maintainers = with maintainers; [ ifurther ];
  };
}
