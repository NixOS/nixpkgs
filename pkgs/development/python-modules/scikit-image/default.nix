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
  version = "0.18.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecae99f93f4c5e9b1bf34959f4dc596c41f2f6b2fc407d9d9ddf85aebd3137ca";
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
