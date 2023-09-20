{ lib
, astropy
, buildPythonPackage
, fetchpatch
, fetchPypi
, matplotlib
, numpy
, pillow
, pyavm
, pyregion
, pytest-astropy
, pytestCheckHook
, pythonOlder
, reproject
, scikit-image
, setuptools
, setuptools-scm
, shapely
, wheel
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "aplpy";
    inherit version;
    hash = "sha256-KCdmBwQWt7IfHsjq7pWlbSISEpfQZDyt+SQSTDaUCV4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    astropy
    matplotlib
    numpy
    pillow
    pyavm
    pyregion
    reproject
    scikit-image
    shapely
  ];

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  preCheck = ''
    OPENMP_EXPECTED=0
  '';

  pythonImportsCheck = [
    "aplpy"
  ];

  meta = with lib; {
    description = "The Astronomical Plotting Library in Python";
    homepage = "http://aplpy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
