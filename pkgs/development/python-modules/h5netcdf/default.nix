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
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h5netcdf";
    repo = "h5netcdf";
    tag = "v${version}";
    hash = "sha256-g7cAUhIrTzWv/ELOWLNMKhm2rM7i+7o4iJS5d4vzal4=";
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
