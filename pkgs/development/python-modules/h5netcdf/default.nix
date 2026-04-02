{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  h5py,
  netcdf,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h5netcdf";
    repo = "h5netcdf";
    tag = "v${version}";
    hash = "sha256-m+8vdWOQb9aIg/mPeTrN20EzTj229Cit3nYgrkPlfGA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ h5py ];

  nativeCheckInputs = [
    netcdf
    pytestCheckHook
  ];

  pythonImportsCheck = [ "h5netcdf" ];

  meta = {
    description = "Pythonic interface to netCDF4 via h5py";
    homepage = "https://github.com/shoyer/h5netcdf";
    changelog = "https://github.com/h5netcdf/h5netcdf/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
