{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, python
, oldest-supported-numpy
, setuptools
, wheel
, numpy
, zlib
, netcdf
, hdf5
, curl
, libjpeg
, cython
, cftime
}:

buildPythonPackage rec {
  pname = "netcdf4";
  version = "1.6.2";
  format = "pyproject";

  disabled = isPyPy;

  src = fetchPypi {
    pname = "netCDF4";
    inherit version;
    hash = "sha256-A4KwL/aiiEGfb/7IXexA9FH0G4dVVHFUxXXd2fD0rlM=";
  };

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    wheel
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
    pushd test/
    NO_NET=1 NO_CDL=1 ${python.interpreter} run_all.py
  '';

  env = {
    # Variables used to configure the build process
    USE_NCCONFIG = "0";
    HDF5_DIR = lib.getDev hdf5;
    NETCDF4_DIR = netcdf;
    CURL_DIR = curl.dev;
    JPEG_DIR = libjpeg.dev;
  } // lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";
  };

  pythonImportsCheck = [ "netCDF4" ];

  meta = with lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = "https://github.com/Unidata/netcdf4-python";
    changelog = "https://github.com/Unidata/netcdf4-python/raw/v${version}/Changelog";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
