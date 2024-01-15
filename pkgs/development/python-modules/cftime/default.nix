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
  version = "1.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0Kayn3KhPwjgCLm+z/JHzHXISsshMzLt4Yh5xbaqTf0=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  nativeBuildInputs = [
    cython
    numpy
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
