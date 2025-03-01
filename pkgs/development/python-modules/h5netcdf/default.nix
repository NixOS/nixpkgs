{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  h5py,
  pytestCheckHook,
  netcdf4,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h5netcdf";
    repo = "h5netcdf";
    tag = "v${version}";
    hash = "sha256-fhLL8/XgYQmdHckh5xhYvnlc+MTIc2wcTOZaohFFGlk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ h5py ];

  nativeCheckInputs = [
    pytestCheckHook
    netcdf4
  ];

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "h5netcdf" ];

  meta = with lib; {
    description = "Pythonic interface to netCDF4 via h5py";
    homepage = "https://github.com/shoyer/h5netcdf";
    changelog = "https://github.com/h5netcdf/h5netcdf/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
