{ lib
, buildPythonPackage
, fetchPypi
, param
, pyct
, pytest-mpl
, pytestCheckHook
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "colorcet";
  version = "3.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KSGzzYGiKIqvLWPbwM48JtzYgujDicxQXWiGv3qppOs=";
  };

  dependencies = [
    param
    pyct
  ];

  build-system = [
    setuptools-scm
    setuptools
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

  disabledTests = [
    "matplotlib_default_colormap_plot"
  ];

  pythonImportsCheck = [
    "colorcet"
  ];

  meta = with lib; {
    description = "Collection of perceptually uniform colormaps";
    mainProgram = "colorcet";
    homepage = "https://colorcet.pyviz.org";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ ];
  };
}
