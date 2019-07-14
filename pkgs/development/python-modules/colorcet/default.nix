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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab1d16aba97f54af190631c7777c356b04b53de549672ff6b01c66d716eddff3";
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

    pytest colorcet
  '';

  meta = with lib; {
    description = "Collection of perceptually uniform colormaps";
    homepage = https://colorcet.pyviz.org;
    license = licenses.cc-by-40;
    maintainers = [ maintainers.costrouc ];
  };
}
