{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oldest-supported-numpy,
  setuptools,
  ansitable,
  matplotlib,
  numpy,
  progress,
  scipy,
  spatialmath-python,
  coverage,
  flake8,
  pytest,
  pytest-timeout,
  pytest-xvfb,
  sympy,
  pillow,
  pyqt5,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bdsim";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BK1lzCwSu9NZZmTaSNyDWPm47bepaQmD0MrbaajDw1g=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
  ];

  propagatedBuildInputs = [
    ansitable
    matplotlib
    numpy
    progress
    scipy
    spatialmath-python
  ];

  passthru.optional-dependencies = {
    dev = [
      coverage
      flake8
      pytest
      pytest-timeout
      pytest-xvfb
      sympy
    ];
    edit = [
      pillow
      pyqt5
    ];
  };

  pythonImportsCheck = [ "bdsim" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # examples not packaged in pypi
    "test_bdrun"
  ];

  meta = with lib; {
    description = "Simulate dynamic systems expressed in block diagram form using Python";
    homepage = "https://pypi.org/project/bdsim/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
