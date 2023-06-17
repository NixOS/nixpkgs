{ lib
, buildPythonPackage
, fetchPypi
, flit-core
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
    hash = "sha256-0CvMhCUc+i7dPiHH+IXdlj+OjFh/l1wvnU4dmxQrzFI=";
  };
  format = "pyproject";

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    scipy
    tabulate
  ];

  nativeCheckInputs = [
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
    # ValueError: Unknown window type: "hanning"
    "tests/standards/test_iso_1996_2_2007.py"
  ];

  pythonImportsCheck = [ "acoustics" ];

  meta = with lib; {
    description = "Python package for acousticians";
    maintainers = with maintainers; [ fridh ];
    license = with licenses; [ bsd3 ];
    homepage = "https://github.com/python-acoustics/python-acoustics";
  };
}
