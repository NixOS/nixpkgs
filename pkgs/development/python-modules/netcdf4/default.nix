{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest
, numpy, zlib, netcdf, hdf5, curl, libjpeg, cython, cftime
}:
buildPythonPackage rec {
  pname = "netCDF4";
  version = "1.5.2";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "08l92yzg2cy1zrkxjvwya2kpnmfzgwnvgb925hlrgcp5ga9y2xg0";
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
  HDF5_DIR=hdf5;
  NETCDF4_DIR=netcdf;
  CURL_DIR=curl.dev;
  JPEG_DIR=libjpeg.dev;

  meta = with stdenv.lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = https://pypi.python.org/pypi/netCDF4;
    license = licenses.free;  # Mix of license (all MIT* like)
  };
}
