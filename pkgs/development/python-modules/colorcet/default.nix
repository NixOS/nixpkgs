{ stdenv
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
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vkx00im4s6zhr2m1j9r0a5vmhkl488b4xpzxb1pidbl19wi6j2i";
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

  meta = with stdenv.lib; {
    description = "Collection of perceptually uniform colormaps";
    homepage = https://colorcet.pyviz.org;
    license = licenses.cc-by-40;
    maintainers = [ maintainers.costrouc ];
  };
}
