{ lib, stdenv
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
  version = "0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a223909e5148c99bd18891848c7871457729322c752c9c470bd8dd6bdf9f940";
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
