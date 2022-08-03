{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, h5py
, pytestCheckHook
, netcdf4
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iAih4JXwEitPtAjMmMYK3zmb1X/vSNHKfN9M2h0Ka0o=";
  };

 nativeBuildInputs = [
   setuptools-scm
 ];

  propagatedBuildInputs = [
    h5py
  ];

  checkInputs = [
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
