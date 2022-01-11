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
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21c522346a7aa81a603729f2996c22ac3f7822f4c8c303c59761e27d2dfcf3db";
  };

  propagatedBuildInputs = [
    param
    pyct
  ];

  checkInputs = [
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
    maintainers = with maintainers; [ costrouc ];
  };
}
