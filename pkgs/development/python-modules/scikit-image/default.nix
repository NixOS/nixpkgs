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
, imageio
}:

buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.17.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd954c0588f0f7e81d9763dc95e06950e68247d540476e06cb77bcbcd8c2d8b3";
  };

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy scipy matplotlib networkx six pillow pywavelets dask cloudpickle imageio ];

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Image processing routines for SciPy";
    homepage = "https://scikit-image.org";
    license = lib.licenses.bsd3;
  };
}
