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
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hhTAD7ilBG3jBP3Ybb0iT5lAgYXXskWsZijQJ2WW5tI=";
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
