{ lib
, buildPythonPackage
, fetchPypi
, param
, pyct
, pytest-mpl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorcet";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UUVaIDU9EvrJH5U3cthAnyR05qDbGvP6T3AF9AWiSAs=";
  };

  propagatedBuildInputs = [
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

  disabledTests = [
    "matplotlib_default_colormap_plot"
  ];

  pythonImportsCheck = [
    "colorcet"
  ];

  meta = with lib; {
    description = "Collection of perceptually uniform colormaps";
    homepage = "https://colorcet.pyviz.org";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ ];
  };
}
