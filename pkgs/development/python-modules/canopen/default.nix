{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, can
, canmatrix
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18d01d56ff0023795cb336cafd4810a76cf402b98b42139b201fa8c5d4ba8c06";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    can
    canmatrix
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "canopen" ];

  meta = with lib; {
    homepage = "https://github.com/christiansandberg/canopen/";
    description = "CANopen stack implementation";
    license = licenses.mit;
    maintainers = with maintainers; [ sorki ];
  };
}
