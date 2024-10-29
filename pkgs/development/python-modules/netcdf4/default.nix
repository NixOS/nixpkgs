{
  lib,
  buildPythonPackage,
  certifi,
  cftime,
  curl,
  cython,
  fetchPypi,
  hdf5,
  isPyPy,
  libjpeg,
  netcdf,
  numpy,
  oldest-supported-numpy,
  python,
  pythonOlder,
  setuptools-scm,
  stdenv,
  wheel,
  zlib,
}:

buildPythonPackage rec {
  pname = "netcdf4";
  version = "1.7.1.post2";
  pyproject = true;

  disabled = isPyPy || pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N9VX42ZUiJ1wIBkr+1b51fk4lMsymX64N65YbFOP17Y=";
  };

  build-system = [
    cython
    oldest-supported-numpy
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    certifi
    cftime
    curl
    hdf5
    libjpeg
    netcdf
    numpy
    zlib
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
  } // lib.optionalAttrs stdenv.cc.isClang { NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion"; };

  pythonImportsCheck = [ "netCDF4" ];

  meta = with lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = "https://github.com/Unidata/netcdf4-python";
    changelog = "https://github.com/Unidata/netcdf4-python/raw/v${version}/Changelog";
    maintainers = [ ];
    license = licenses.mit;
  };
}
