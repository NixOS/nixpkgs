{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, can
, canmatrix
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vMiqnqg/etpdoNregQOJd75SqTgCwmV2SXKesfggZdk=";
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

  pythonImportsCheck = [
    "canopen"
  ];

  meta = with lib; {
    homepage = "https://github.com/christiansandberg/canopen/";
    description = "CANopen stack implementation";
    license = licenses.mit;
    maintainers = with maintainers; [ sorki ];
  };
}
