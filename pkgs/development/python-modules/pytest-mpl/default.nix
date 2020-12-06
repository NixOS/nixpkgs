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
  version = "0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a223909e5148c99bd18891848c7871457729322c752c9c470bd8dd6bdf9f940";
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
    homepage = "https://github.com/matplotlib/pytest-mpl";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
