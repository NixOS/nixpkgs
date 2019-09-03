{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, matplotlib
, nose
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7006e63bf1ca9c50bea3d189c0f862751a16ce40bb373197b218f57af5b837c0";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    matplotlib
    nose
  ];

  checkInputs = [
    pytest
  ];

  # disable tests on darwin, because it requires a framework build of Python
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc

    pytest
  '';

  meta = with stdenv.lib; {
    description = "Pytest plugin to help with testing figures output from Matplotlib";
    homepage = https://github.com/matplotlib/pytest-mpl;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
