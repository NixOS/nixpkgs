{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  astropy,
  dill,
  echo,
  fast-histogram,
  h5py,
  ipython,
  matplotlib,
  mpl-scatter-density,
  numpy,
  openpyxl,
  pandas,
  pyqt-builder,
  pytestCheckHook,
  qt6,
  scipy,
  setuptools,
  setuptools-scm,
  shapely,
  xlrd,
}:

buildPythonPackage rec {
  pname = "glueviz";
  version = "1.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "glue";
    tag = "v${version}";
    hash = "sha256-21XFH1fIt8vLd0blZJn6ZRmLJaof/E30zHrBVLjXOaA=";
  };

  buildInputs = [ pyqt-builder ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy
    dill
    echo
    fast-histogram
    h5py
    ipython
    matplotlib
    mpl-scatter-density
    numpy
    openpyxl
    pandas
    scipy
    setuptools
    shapely
    xlrd
  ];

  dontConfigure = true;

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "glue" ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://glueviz.org";
    description = "Linked Data Visualizations Across Multiple Files";
    license = lib.licenses.bsd3; # https://github.com/glue-viz/glue/blob/main/LICENSE
    maintainers = with lib.maintainers; [ ifurther ];
  };
}
