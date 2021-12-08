{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "python-acoustics";
     repo = "python-acoustics";
     rev = "v0.2.4.post0";
     sha256 = "0fhj02611590rci5vb2r236jn1jbj3zaaza40dfw6rqx9jwfqizn";
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
