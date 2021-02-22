{ lib
, buildPythonPackage
, fetchPypi
, param
, pyct
, nbsmoke
, flake8
, pytest
, pytest-mpl
}:

buildPythonPackage rec {
  pname = "colorcet";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efa44b6f4078261e62d0039c76aba17ac8d3ebaf0bc2291a111aee3905313433";
  };

  propagatedBuildInputs = [
    param
    pyct
  ];

  checkInputs = [
    nbsmoke
    pytest
    flake8
    pytest-mpl
  ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib

    # requires other backends to be available
    pytest colorcet -k 'not matplotlib_default_colormap_plot'
  '';

  meta = with lib; {
    description = "Collection of perceptually uniform colormaps";
    homepage = "https://colorcet.pyviz.org";
    license = licenses.cc-by-40;
    maintainers = [ maintainers.costrouc ];
  };
}
