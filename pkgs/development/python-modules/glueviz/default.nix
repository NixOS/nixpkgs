{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
}:
buildPythonPackage rec {
  pname = "glueviz";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glue-viz";
    repo = "glueviz";
    tag = "v${version}";
    hash = "sha256-R2yzeq/+VV7TAl/kAwJyTI6o5PfdM5jBFR9IV48cqlU=";
  };

  build-system = with python.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python.pkgs; [
    ipython
    matplotlib
    mpl-scatter-density
    numpy
    glue-core
    glue-qt
    glue-vispy-viewers
  ];

  dontConfigure = true;

  # collecting ... qt.qpa.xcb: could not connect to display
  # qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
  doCheck = false;

  dontWrapQtApps = true;

  # it just a meta package
  pythonImportsCheck = [ "glue" ];

  meta = with lib; {
    homepage = "https://glueviz.org";
    description = "The glueviz meta-package";
    license = licenses.bsd3; # https://github.com/glue-viz/glueviz/blob/main/LICENSE
    maintainers = with maintainers; [ ifurther ];
  };
}
