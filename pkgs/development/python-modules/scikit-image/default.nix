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
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "325f75eb80fbc5371136e37f323445309ca9f65b6c6f718d0d0e2189e5de1224";
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