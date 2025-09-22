{
  lib,
  buildPythonPackage,
  certifi,
  cftime,
  curl,
  cython,
  fetchFromGitHub,
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

let
  version = "1.7.2";
  suffix = lib.optionalString (lib.match ''.*\.post[0-9]+'' version == null) "rel";
  tag = "v${version}${suffix}";
in
buildPythonPackage {
  pname = "netcdf4";
  inherit version;
  pyproject = true;

  disabled = isPyPy || pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "netcdf4-python";
    inherit tag;
    hash = "sha256-orwCHKOSam+2eRY/yAduFYWREOkJlWIJGIZPZwQZ/RI=";
  };

  build-system = [
    cython
    oldest-supported-numpy
    setuptools-scm
    wheel
  ];

  dependencies = [
    certifi
    cftime
    numpy
  ];

  buildInputs = [
    curl
    hdf5
    libjpeg
    netcdf
    zlib
  ];

  checkPhase = ''
    runHook preCheck

    pushd test/
    NO_NET=1 NO_CDL=1 ${python.interpreter} run_all.py

    runHook postCheck
  '';

  env = {
    # Variables used to configure the build process
    USE_NCCONFIG = "0";
    HDF5_DIR = lib.getDev hdf5;
    NETCDF4_DIR = netcdf;
    CURL_DIR = curl.dev;
    JPEG_DIR = libjpeg.dev;
  }
  // lib.optionalAttrs stdenv.cc.isClang { NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion"; };

  pythonImportsCheck = [ "netCDF4" ];

  meta = with lib; {
    description = "Interface to netCDF library (versions 3 and 4)";
    homepage = "https://github.com/Unidata/netcdf4-python";
    changelog = "https://github.com/Unidata/netcdf4-python/raw/${tag}/Changelog";
    maintainers = [ ];
    license = licenses.mit;
  };
}
