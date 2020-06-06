{ lib
, buildPythonPackage
, fetchPypi
, h5py
, pytestCheckHook
, netcdf4
, pythonOlder
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0df12f4692817cf6d8e2fca95f689e61aa68f2f39aea90fd1790fe5ac8d2cbb";
  };

  propagatedBuildInputs = [
    h5py
  ];

  checkInputs = [
    pytestCheckHook
    netcdf4
  ];

  disabled = pythonOlder "3.6";

  dontUseSetuptoolsCheck = true;

  meta = {
    description = "netCDF4 via h5py";
    homepage = https://github.com/shoyer/h5netcdf;
    license = lib.licenses.bsd3;
  };

}