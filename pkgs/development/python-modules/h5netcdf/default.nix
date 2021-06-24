{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, h5py
, pytestCheckHook
, netcdf4
, pythonOlder
}:

buildPythonPackage rec {
  pname = "h5netcdf";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09bbnpsvwksb07wijn7flyyza56h5b2g2cw0hb3slmwxz6cgcjmr";
  };

  patches = [
    (fetchpatch{
      url = "https://patch-diff.githubusercontent.com/raw/h5netcdf/h5netcdf/pull/82.patch";
    sha256 = "0x9bq9jl4kvw152adkpcyqslhpi7miv80hrnpl2w2y798mmbs0s4";
    })
  ];

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
    homepage = "https://github.com/shoyer/h5netcdf";
    license = lib.licenses.bsd3;
  };

}
