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
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "375d37d9ab8bf501c048e44efce2276296e3d67bb276e891e0e93b0a8bbb988a";
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
