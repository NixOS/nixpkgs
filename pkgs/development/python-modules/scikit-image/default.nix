{ lib
, fetchPypi
, buildPythonPackage
, cython
, numpy
, scipy
, matplotlib
, networkx
, six
, pillow
, pywavelets
, dask
, cloudpickle
, pytest
}:

buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86a9b3b4f74f231e0a6bcfd3235dcf3f0118df25dac21201da5e064d681e2c50";
  };

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy scipy matplotlib networkx six pillow pywavelets dask cloudpickle ];

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Image processing routines for SciPy";
    homepage = http://scikit-image.org;
    license = lib.licenses.bsd3;
  };
}