{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest
, numpy, zlib, netcdf, hdf5, curl, libjpeg, cython, cftime
}:
buildPythonPackage rec {
  pname = "netCDF4";
  version = "1.4.1";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4fc65b98e348c39d082ab6b4b7f6d636b1b4e63bec016e5bca189fee5d46403";
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
  HDF5_DIR="${hdf5}";
  NETCDF4_DIR="${netcdf}";
  CURL_DIR="${curl.dev}";
  JPEG_DIR="${libjpeg.dev}";

  meta = with stdenv.lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = https://pypi.python.org/pypi/netCDF4;
    license = licenses.free;  # Mix of license (all MIT* like)
  };
}
