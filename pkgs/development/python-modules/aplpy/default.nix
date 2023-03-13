{ lib
, astropy
, astropy-helpers
, buildPythonPackage
, cython
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
, scikitimage
, shapely
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
    astropy-helpers
  ];

  propagatedBuildInputs = [
    astropy
    cython
    matplotlib
    numpy
    pillow
    pyavm
    pyregion
    reproject
    scikitimage
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
