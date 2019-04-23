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
  version = "0.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1afd0b84eefd77afd1071c5c1c402553d67be2d7db8950b32d6f773f25850c1f";
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