{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, python
, setuptools
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
  pname = "netCDF4";
  version = "1.6.2";
  format = "pyproject";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A4KwL/aiiEGfb/7IXexA9FH0G4dVVHFUxXXd2fD0rlM=";
  };

  nativeBuildInputs = [ setuptools cython ];

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

  # Variables used to configure the build process
  USE_NCCONFIG = "0";
  HDF5_DIR = lib.getDev hdf5;
  NETCDF4_DIR = netcdf;
  CURL_DIR = curl.dev;
  JPEG_DIR = libjpeg.dev;

  pythonImportsCheckHook = [ "netcdf4" ];

  meta = with lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = "https://github.com/Unidata/netcdf4-python";
    changelog = "https://github.com/Unidata/netcdf4-python/raw/v${version}/Changelog";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
