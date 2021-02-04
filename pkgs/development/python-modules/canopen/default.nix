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
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15d49f1f71e9989dde6e3b75fb8445c76bd223064dfc0ac629fe9ecb0e21fba9";
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
