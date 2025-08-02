{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  python-can,
  canmatrix,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "2.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eSCEqTwTjVsqQG3dLU61ziCPA72P2mD4GtK7jVbGuCc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    python-can
    canmatrix
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "canopen" ];

  meta = with lib; {
    description = "CANopen stack implementation";
    homepage = "https://github.com/christiansandberg/canopen/";
    changelog = "https://github.com/christiansandberg/canopen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sorki ];
  };
}
