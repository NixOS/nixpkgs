{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  param,
  pyct,
  pytest-mpl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorcet";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KSGzzYGiKIqvLWPbwM48JtzYgujDicxQXWiGv3qppOs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    param
    pyct
  ];

  nativeCheckInputs = [
    pytest-mpl
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib
  '';

  disabledTests = [ "matplotlib_default_colormap_plot" ];

  pythonImportsCheck = [ "colorcet" ];

  meta = with lib; {
    description = "Collection of perceptually uniform colormaps";
    mainProgram = "colorcet";
    homepage = "https://colorcet.pyviz.org";
    license = licenses.cc-by-40;
    maintainers = [ ];
  };
}
