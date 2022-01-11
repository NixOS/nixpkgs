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
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "582db6e14315f9b08cbd2df39b136dc344bfe8a27c2f05b995460fb0969ec19e";
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
