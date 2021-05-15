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
, tifffile
}:

buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fbb618ca911867bce45574c1639618cdfb5d94e207432b19bc19563d80d2f171";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    cloudpickle
    dask
    imageio
    matplotlib
    networkx
    numpy
    pillow
    pywavelets
    scipy
    six
    tifffile
  ];

  checkInputs = [ pytest ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Image processing routines for SciPy";
    homepage = "https://scikit-image.org";
    license = lib.licenses.bsd3;
  };
}
