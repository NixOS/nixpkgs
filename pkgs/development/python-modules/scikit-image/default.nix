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
  version = "0.14.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f064315cd6fb048560ac6eb03e41969aab68f9df5c145fefaece3b6823e5919";
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