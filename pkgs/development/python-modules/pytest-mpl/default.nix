{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, matplotlib
, nose
, pillow
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26c5a47a8fdbc04652f18b65c587da642c6cc0354680ee44b16c161d9800a2ce";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    matplotlib
    nose
    pillow
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib

    pytest
  '';

  meta = with stdenv.lib; {
    description = "Pytest plugin to help with testing figures output from Matplotlib";
    homepage = https://github.com/matplotlib/pytest-mpl;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
