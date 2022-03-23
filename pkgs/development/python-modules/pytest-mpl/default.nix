{ lib
, buildPythonPackage
, fetchPypi
, pytest
, matplotlib
, nose
, pillow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iE4HjS1TgK9WQzhOIzw1jpZZgl+y2X/9r48YXENMjYk=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    matplotlib
    nose
    pillow
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Broken since b6e98f18950c2b5dbdc725c1181df2ad1be19fee
  disabledTests = [
    "test_hash_fails"
    "test_hash_missing"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib
  '';

  meta = with lib; {
    description = "Pytest plugin to help with testing figures output from Matplotlib";
    homepage = "https://github.com/matplotlib/pytest-mpl";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
