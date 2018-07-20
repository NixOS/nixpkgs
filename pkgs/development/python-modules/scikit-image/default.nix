{ lib
, fetchPypi
, buildPythonPackage
, cython
, dask
, nose
, numpy
, scipy
, six
, pillow
, matplotlib
, networkx
}:

buildPythonPackage rec {
  pname = "scikit-image";
  version = "0.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1iypjww5hk46i9vzg2zlfc9w4vdw029cfyakkkl02isj1qpiknl2";
  };

  buildInputs = [ cython dask nose ];

  propagatedBuildInputs = [ pillow matplotlib networkx scipy six numpy ];

  # the test fails because the loader cannot create test objects!
  doCheck = false;

  meta = {
    description = "Image processing routines for SciPy";
    homepage = http://scikit-image.org;
    license = lib.licenses.bsd3;
  };
}