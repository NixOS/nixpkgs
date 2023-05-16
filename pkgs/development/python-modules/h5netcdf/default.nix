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
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kyw7Vzvtc3Dr/J6ALNYPGk2lI277EbNu7/iXMk12v1Y=";
  };

<<<<<<< HEAD
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];
=======
 nativeBuildInputs = [
   setuptools-scm
 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
