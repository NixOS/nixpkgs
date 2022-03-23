{ lib
, buildPythonPackage
, cython
, fetchPypi
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ExA+ZlC+6mVSMWvVgl1qo7fpj1uBFQJt9IJnmN/590E=";
  };

  nativeBuildInputs = [
    cython
    numpy
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  pythonImportsCheck = [
    "cftime"
  ];

  meta = with lib; {
    description = "Time-handling functionality from netcdf4-python";
    homepage = "https://github.com/Unidata/cftime";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
