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
  version = "0.16.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd7fbd32da74d4e9967dc15845f731f16e7966cee61f5dc0e12e2abb1305068c";
  };

  buildInputs = [ cython ];

  propagatedBuildInputs = [ numpy scipy matplotlib networkx six pillow pywavelets dask cloudpickle imageio ];

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Image processing routines for SciPy";
    homepage = https://scikit-image.org;
    license = lib.licenses.bsd3;
  };
}
