{ lib
, buildPythonPackage
, fetchPypi
, h5py
, pytestCheckHook
, netcdf4
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oXHAJ9rrNLJMJKO2MEGVuOq7tvEMdIJW7Tz+GYBjg88=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    h5py
  ];

  nativeCheckInputs = [
    pytestCheckHook
    netcdf4
  ];

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [
    "h5netcdf"
  ];

  meta = with lib; {
    description = "netCDF4 via h5py";
    homepage = "https://github.com/shoyer/h5netcdf";
    changelog = "https://github.com/h5netcdf/h5netcdf/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
