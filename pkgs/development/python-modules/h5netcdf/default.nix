{
  lib,
  buildPythonPackage,
  fetchPypi,
  h5py,
  pytestCheckHook,
  netcdf4,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fIQBq4B/83yXmO3JDZlGdZWJLmxUGl1avrj1OqtTNf4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ h5py ];

  nativeCheckInputs = [
    pytestCheckHook
    netcdf4
  ];

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "h5netcdf" ];

  meta = with lib; {
    description = "netCDF4 via h5py";
    homepage = "https://github.com/shoyer/h5netcdf";
    changelog = "https://github.com/h5netcdf/h5netcdf/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
