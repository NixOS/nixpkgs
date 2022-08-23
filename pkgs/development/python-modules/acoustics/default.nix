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
  version = "0.2.6";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0CvMhCUc+i7dPiHH+IXdlj+OjFh/l1wvnU4dmxQrzFI=";
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
