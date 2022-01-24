{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, scipy
, tabulate
}:

buildPythonPackage rec {
  pname = "acoustics";
  version = "0.2.4.post0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a162625e5e70ed830fab8fab0ddcfe35333cb390cd24b0a827bcefc5bbcae97d";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    scipy
    tabulate
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  pytestFlagsArray = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # All tests fail with TypeError
    "tests/test_aio.py"
  ];

  pythonImportsCheck = [ "acoustics" ];

  meta = with lib; {
    description = "Python package for acousticians";
    maintainers = with maintainers; [ fridh ];
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/python-acoustics/python-acoustics";
  };
}
