{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, numpy
, astropy
, astropy-helpers
, matplotlib
, reproject
, pyavm
, pyregion
, pillow
, scikitimage
, cython
, shapely
, pytest
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "aplpy";
  version = "2.1.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "aplpy";
    inherit version;
    sha256 = "sha256-KCdmBwQWt7IfHsjq7pWlbSISEpfQZDyt+SQSTDaUCV4=";
  };

  propagatedBuildInputs = [
    numpy
    cython
    astropy
    matplotlib
    reproject
    pyavm
    pyregion
    pillow
    scikitimage
    shapely
  ];

  nativeBuildInputs = [ astropy-helpers ];
  checkInputs = [ pytest pytest-astropy ];

  checkPhase = ''
    OPENMP_EXPECTED=0 pytest aplpy
  '';

  meta = with lib; {
    description = "The Astronomical Plotting Library in Python";
    homepage = "http://aplpy.github.io";
    license = licenses.mit;
    maintainers = [ maintainers.smaret ];
  };
}
