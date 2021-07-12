{ lib, buildPythonPackage, fetchPypi, isPyPy, pytest
, numpy, zlib, netcdf, hdf5, curl, libjpeg, cython, cftime
}:
buildPythonPackage rec {
  pname = "netCDF4";
  version = "1.5.6";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7577f4656af8431b2fa6b6797acb45f81fa1890120e9123b3645e14765da5a7c";
  };

  checkInputs = [ pytest ];

  buildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    cftime
    numpy
    zlib
    netcdf
    hdf5
    curl
    libjpeg
  ];

  checkPhase = ''
    py.test test/tst_*.py
  '';

  # Tests need fixing.
  doCheck = false;

  # Variables used to configure the build process
  USE_NCCONFIG="0";
  HDF5_DIR = lib.getDev hdf5;
  NETCDF4_DIR=netcdf;
  CURL_DIR=curl.dev;
  JPEG_DIR=libjpeg.dev;

  meta = with lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = "https://pypi.python.org/pypi/netCDF4";
    license = licenses.free;  # Mix of license (all MIT* like)
  };
}
